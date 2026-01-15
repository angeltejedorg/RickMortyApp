//
//  CharacterRepository.swift
//  RickyMortyApp
//
//  Created by Angel Tejedor on 14/01/26.
//

import Foundation

protocol CharacterRepository {
    func fetchCharacters(page: Int, name: String?, status: CharacterStatus?) async throws -> CharacterPage
    func fetchCharacter(id: Int) async throws -> Character
}

