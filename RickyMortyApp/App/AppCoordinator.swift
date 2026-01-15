//
//  AppCoordinator.swift
//  RickyMortyApp
//
//  Created by Angel Tejedor on 14/01/26.
//

import Foundation


@MainActor
final class AppCoordinator: ObservableObject {
    
    // MARK: - Dependencies

    private let repository: CharacterRepository
    
    init(repository: CharacterRepository) {
        self.repository = repository
    }
    
    // MARK: - Initializacion

    
    func makeCharacterListViewModel() -> CharacterListViewModel {
        CharacterListViewModel(repository: repository)
    }
    
    // MARK: - Factory Methods

    func makeCharacterDetailViewModel(characterId: Int) -> CharacterDetailViewModel {
        CharacterDetailViewModel(characterId: characterId, repository: repository)
    }
}
