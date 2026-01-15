//
//  CharacterListViewModelTests.swift
//  RickyMortyAppTests
//
//  Created by Angel Tejedor on 15/01/26.
//

import XCTest
@testable import RickyMortyApp

@MainActor
final class CharacterListViewModelTests: XCTestCase {
    
    private var mockRepository: MockCharacterRepository!
    private var sut: CharacterListViewModel!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockCharacterRepository()
        // Use debounceInterval = 0 for deterministic tests
        sut = CharacterListViewModel(repository: mockRepository, debounceInterval: 0)
    }
    
    override func tearDown() {
        mockRepository = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Initial Load Tests
    
    func test_loadInitial_success_setsLoadedState() async {
        // Given
        mockRepository.fetchCharactersResult = .success(TestData.samplePage)
        
        // When
        await sut.loadInitial()
        
        // Then
        if case .loaded(let characters, let canLoadMore) = sut.state {
            XCTAssertEqual(characters.count, 2)
            XCTAssertTrue(canLoadMore)
        } else {
            XCTFail("Expected loaded state, got \(sut.state)")
        }
    }
    
    func test_loadInitial_emptyResults_setsEmptyState() async {
        // Given
        mockRepository.fetchCharactersResult = .success(TestData.emptyPage)
        
        // When
        await sut.loadInitial()
        
        // Then
        XCTAssertEqual(sut.state, .empty)
    }
    
    func test_loadInitial_error_setsErrorState() async {
        // Given
        mockRepository.fetchCharactersResult = .failure(APIError.networkError("No connection"))
        
        // When
        await sut.loadInitial()
        
        // Then
        if case .error(let message) = sut.state {
            XCTAssertEqual(message, APIError.networkError("No connection").userMessage)
        } else {
            XCTFail("Expected error state, got \(sut.state)")
        }
    }
    
    func test_loadInitial_notFoundError_setsEmptyState() async {
        // Given
        mockRepository.fetchCharactersResult = .failure(APIError.notFound)
        
        // When
        await sut.loadInitial()
        
        // Then
        XCTAssertEqual(sut.state, .empty)
    }
    
    // MARK: - Search Tests
    
    func test_searchTextChanged_resetsPaginationAndFetches() async {
        // Given
        mockRepository.fetchCharactersResult = .success(TestData.samplePage)
        await sut.loadInitial()
        
        // When
        sut.searchText = "Rick"
        sut.onSearchTextChanged()
        
        // Wait for debounce (0ms) + fetch
        try? await Task.sleep(nanoseconds: 50_000_000)
        
        // Then
        XCTAssertEqual(mockRepository.fetchCharactersCallCount, 2) // Initial + search
        XCTAssertEqual(mockRepository.lastFetchCharactersPage, 1) // Reset to page 1
        XCTAssertEqual(mockRepository.lastFetchCharactersName, "Rick")
    }
    
    func test_searchTextEmpty_sendsNilName() async {
        // Given
        mockRepository.fetchCharactersResult = .success(TestData.samplePage)
        
        // When
        sut.searchText = ""
        await sut.loadInitial()
        
        // Then
        XCTAssertNil(mockRepository.lastFetchCharactersName)
    }
    
    // MARK: - Filter Tests
    
    func test_statusFilterChanged_resetsPaginationAndFetches() async {
        // Given
        mockRepository.fetchCharactersResult = .success(TestData.samplePage)
        await sut.loadInitial()
        
        // When
        sut.statusFilter = .alive
        sut.onStatusFilterChanged()
        
        // Wait for fetch
        try? await Task.sleep(nanoseconds: 50_000_000)
        
        // Then
        XCTAssertEqual(mockRepository.fetchCharactersCallCount, 2) // Initial + filter
        XCTAssertEqual(mockRepository.lastFetchCharactersPage, 1) // Reset to page 1
        XCTAssertEqual(mockRepository.lastFetchCharactersStatus, .alive)
    }
    
    func test_statusFilterAll_sendsNilStatus() async {
        // Given
        mockRepository.fetchCharactersResult = .success(TestData.samplePage)
        
        // When
        sut.statusFilter = .all
        await sut.loadInitial()
        
        // Then
        XCTAssertNil(mockRepository.lastFetchCharactersStatus)
    }
    
    // MARK: - Pagination Tests
    
    func test_loadMore_appendsCharactersAndIncrementsPage() async {
        // Given
        mockRepository.fetchCharactersResult = .success(TestData.samplePage)
        await sut.loadInitial()
        
        // When
        await sut.loadMore()
        
        // Then
        XCTAssertEqual(mockRepository.fetchCharactersCallCount, 2)
        XCTAssertEqual(mockRepository.lastFetchCharactersPage, 2)
        
        if case .loaded(let characters, _) = sut.state {
            XCTAssertEqual(characters.count, 4) // 2 from initial + 2 from loadMore
        } else {
            XCTFail("Expected loaded state")
        }
    }
    
    func test_loadMore_whenNoMorePages_doesNotFetch() async {
        // Given
        mockRepository.fetchCharactersResult = .success(TestData.samplePageNoMore)
        await sut.loadInitial()
        
        // When
        await sut.loadMore()
        
        // Then
        XCTAssertEqual(mockRepository.fetchCharactersCallCount, 1) // Only initial
    }
    
    // MARK: - Retry Tests
    
    func test_retry_afterError_fetchesAgain() async {
        // Given
        mockRepository.fetchCharactersResult = .failure(APIError.networkError("No connection"))
        await sut.loadInitial()
        XCTAssertEqual(sut.state, .error(APIError.networkError("No connection").userMessage))
        
        // When
        mockRepository.fetchCharactersResult = .success(TestData.samplePage)
        await sut.retry()
        
        // Then
        if case .loaded(let characters, _) = sut.state {
            XCTAssertEqual(characters.count, 2)
        } else {
            XCTFail("Expected loaded state after retry")
        }
    }
}

