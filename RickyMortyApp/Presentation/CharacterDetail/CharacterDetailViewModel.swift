//
//  CharacterDetailViewModel.swift
//  RickyMortyApp
//
//  Created by Angel Tejedor on 14/01/26.
//

import Foundation

@MainActor
final class CharacterDetailViewModel: ObservableObject {
    
    // MARK: - Published Properties

    @Published private(set) var state: CharacterDetailViewState = .loading
    
    // MARK: - Private Properties
    
    private let characterId: Int
    private let repository: CharacterRepository
    
    // MARK: - Initialization

    init(characterId: Int, repository: CharacterRepository) {
        self.characterId = characterId
        self.repository = repository
    }
    
    // MARK: - Public Methods

    func loadCharacter() async {
        state = .loading
        
        do {
            let character = try await repository.fetchCharacter(id: characterId)
            state = .loaded(character)
        } catch let error as APIError {
            state = .error(error.userMessage)
        } catch {
            state = .error("An unexpected error ocurred.")
        }
    }
    
    func retry() async {
        await loadCharacter()
    }
}
