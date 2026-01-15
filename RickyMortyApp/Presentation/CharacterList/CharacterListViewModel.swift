//
//  CharacterListViewModel.swift
//  RickyMortyApp
//
//  Created by Angel Tejedor on 14/01/26.
//

import Foundation

@MainActor
final class CharacterListViewModel: ObservableObject {
    
    // MARK: - Published Properties

    @Published private(set) var state: CharacterListViewState = .idle
    @Published var searchText: String = ""
    @Published var statusFilter: StatusFilter = .all
    @Published private(set) var isLoadingMore: Bool = false
    
    // MARK: - Private Properties

    private var characters: [Character] = []
    private var currentPage: Int = 1
    private var canLoadMore: Bool = true
    private var searchTask: Task<Void, Never>?
    
    private let repository: CharacterRepository
    private let debounceInterval: UInt64
    
    // MARK: - Initialization

    init(repository: CharacterRepository, debounceInterval: UInt64 = 300_000_000) {
        self.repository = repository
        self.debounceInterval = debounceInterval
    }
    
    // MARK: - Public Methods

    func onSearchTextChanged() {
        searchTask?.cancel()
        searchTask = Task {
            try? await Task.sleep(nanoseconds: debounceInterval)
            guard !Task.isCancelled else { return }
            await resetAndFetch()
        }
    }
    
    func onStatusFilterChanged() {
        Task { await resetAndFetch() }
    }
    
    func loadInitial() async {
        await resetAndFetch()
    }
    
    func loadMore() async {
        guard canLoadMore, !isLoadingMore, case .loaded = state else { return }
        isLoadingMore = true
        currentPage += 1
        
        do {
            let page = try await repository.fetchCharacters(
                page: currentPage,
                name: searchText.isEmpty ? nil : searchText,
                status: statusFilter.apiStatus
            )
            characters.append(contentsOf: page.results)
            canLoadMore = page.info.next != nil
            state = .loaded(characters: characters, canLoadMore: canLoadMore)
        } catch {
            currentPage -= 1
        }
        
        isLoadingMore = false
    }
    
    func retry() async {
        await resetAndFetch()
    }
    
    // MARK: - Private Methods

    private func resetAndFetch() async {
        currentPage = 1
        characters = []
        canLoadMore = true
        state = .loading
        
        do {
            let page = try await repository.fetchCharacters(
                page: currentPage,
                name: searchText.isEmpty ? nil : searchText,
                status: statusFilter.apiStatus
            )
            
            characters = page.results
            canLoadMore = page.info.next != nil
            state = characters.isEmpty ? .empty : .loaded(characters: characters, canLoadMore: canLoadMore)
        } catch let error as APIError {
            state = error == .notFound ? .empty : .error(error.userMessage)
        } catch {
            state = .error("An unexpected error ocurred.")
        }
    }
}
