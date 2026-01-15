//
//  AppCoordinatorTests.swift
//  RickyMortyAppTests
//
//  Created by Angel Tejedor on 15/01/26.
//

import XCTest
@testable import RickyMortyApp

@MainActor
final class AppCoordinatorTests: XCTestCase {
    
    private var mockRepository: MockCharacterRepository!
    private var sut: AppCoordinator!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockCharacterRepository()
        sut = AppCoordinator(repository: mockRepository)
    }
    
    override func tearDown() {
        mockRepository = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Factory Tests
    
    func test_makeCharacterListViewModel_createsViewModel() {
        // When
        let viewModel = sut.makeCharacterListViewModel()
        
        // Then
        XCTAssertNotNil(viewModel)
        XCTAssertEqual(viewModel.state, .idle)
    }
    
    func test_makeCharacterDetailViewModel_createsViewModelWithCorrectId() async {
        // Given
        mockRepository.fetchCharacterResult = .success(TestData.sampleCharacter)
        
        // When
        let viewModel = sut.makeCharacterDetailViewModel(characterId: 1)
        await viewModel.loadCharacter()
        
        // Then
        if case .loaded(let character) = viewModel.state {
            XCTAssertEqual(character.id, 1)
        } else {
            XCTFail("Expected loaded state")
        }
    }
}

