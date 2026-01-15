//
//  CharacterListView.swift
//  RickyMortyApp
//
//  Created by Angel Tejedor on 14/01/26.
//

import SwiftUI

struct CharacterListView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var viewModel: CharacterListViewModel
    
    init(viewModel: CharacterListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                filterPicker
                content
            }
            .navigationTitle("Characters")
            .searchable(text: $viewModel.searchText, prompt: "Search by name")
            .onChange(of: viewModel.searchText) { _, _ in
                viewModel.onSearchTextChanged()
            }
            .onChange(of: viewModel.statusFilter) { _, _ in
                viewModel.onStatusFilterChanged()
            }
            .task {
                await viewModel.loadInitial()
            }
            .navigationDestination(for: Character.self) { character in
                CharacterDetailView(viewModel: coordinator.makeCharacterDetailViewModel(characterId: character.id))
            }
        }
    }
    
    // MARK: - Filter Picker
    
    private var filterPicker: some View {
        Picker("Status", selection: $viewModel.statusFilter) {
            ForEach(StatusFilter.allCases, id: \.self) { filter in
                Text(filter.rawValue).tag(filter)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    // MARK: - Content
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            LoadingView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
    
        case .empty:
            EmptyStateView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .error(let message):
            ErrorView(message: message) {
                Task { await viewModel.retry() }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .loaded(let characters, let canLoadMore):
            characterList(characters, canLoadMore: canLoadMore)
        }
    }
    
    // MARK: - Character List
    
    private func characterList(_ characters: [Character], canLoadMore: Bool) -> some View {
        List {
            ForEach(characters) { character in
                NavigationLink(value: character) {
                    CharacterRowView(character: character)
                }
                .listRowBackground(Color(.systemBackground))
                .onAppear {
                    if character.id == characters.last?.id {
                        Task { await viewModel.loadMore() }
                    }
                }
            }
            
            if canLoadMore {
                HStack {
                    Spacer()
                    if viewModel.isLoadingMore {
                        ProgressView()
                            .padding()
                    }
                    Spacer()
                }
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    let apiClient = APIClient()
    let repository = CharacterRepositoryImpl(apiClient: apiClient)
    let coordinator = AppCoordinator(repository: repository)
    
    return CharacterListView(viewModel: coordinator.makeCharacterListViewModel())
        .environmentObject(coordinator)
}
