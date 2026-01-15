//
//  RickyMortyAppApp.swift
//  RickyMortyApp
//
//  Created by Angel Tejedor on 14/01/26.
//

import SwiftUI

@main
struct RickyMortyApp: App {
    
    // MARK: - Dependencies

    @StateObject private var coordinator: AppCoordinator
    
    // MARK: - Initalization

    init() {
        let apiClient = APIClient()
        let repository = CharacterRepositoryImpl(apiClient: apiClient)
        let coordinator = AppCoordinator(repository: repository)
        _coordinator = StateObject(wrappedValue: coordinator)
    }
    
    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            CharacterListView(viewModel: coordinator.makeCharacterListViewModel())
                .environmentObject(coordinator)
        }
    }
}
