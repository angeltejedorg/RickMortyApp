//
//  MockCharacterRepository.swift
//  RickyMortyAppTests
//
//  Created by Angel Tejedor on 15/01/26.
//

import Foundation
@testable import RickyMortyApp

final class MockCharacterRepository: CharacterRepository {
    
    var fetchCharactersResult: Result<CharacterPage, Error>!
    var fetchCharacterResult: Result<Character, Error>!
    
    var fetchCharactersCallCount = 0
    var lastFetchCharactersPage: Int?
    var lastFetchCharactersName: String?
    var lastFetchCharactersStatus: CharacterStatus?
    
    func fetchCharacters(page: Int, name: String?, status: CharacterStatus?) async throws -> CharacterPage {
        fetchCharactersCallCount += 1
        lastFetchCharactersPage = page
        lastFetchCharactersName = name
        lastFetchCharactersStatus = status
        return try fetchCharactersResult.get()
    }
    
    func fetchCharacter(id: Int) async throws -> Character {
        return try fetchCharacterResult.get()
    }
}

