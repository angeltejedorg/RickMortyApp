//
//  CharacterRepositoryImpl.swift
//  RickyMortyApp
//
//  Created by Angel Tejedor on 14/01/26.
//

import Foundation

final class CharacterRepositoryImpl: CharacterRepository {
    
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func fetchCharacters(page: Int, name: String?, status: CharacterStatus?) async throws -> CharacterPage {
        try await apiClient.fetch(.characterList(page: page, name: name, status: status))
    }
    
    func fetchCharacter(id: Int) async throws -> Character {
        try await apiClient.fetch(.characterDetail(id: id))
    }
    
}
