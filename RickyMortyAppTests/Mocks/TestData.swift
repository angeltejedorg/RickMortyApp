//
//  TestData.swift
//  RickyMortyAppTests
//
//  Created by Angel Tejedor on 15/01/26.
//

import Foundation
@testable import RickyMortyApp

enum TestData {
    
    // MARK: - Sample Character
    
    static let sampleCharacter = Character(
        id: 1,
        name: "Rick Sanchez",
        status: .alive,
        species: "Human",
        gender: .male,
        origin: Character.Location(name: "Earth (C-137)", url: "https://rickandmortyapi.com/api/location/1"),
        location: Character.Location(name: "Citadel of Ricks", url: "https://rickandmortyapi.com/api/location/3"),
        image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
        episode: [
            "https://rickandmortyapi.com/api/episode/1",
            "https://rickandmortyapi.com/api/episode/2"
        ]
    )
    
    static let sampleCharacter2 = Character(
        id: 2,
        name: "Morty Smith",
        status: .alive,
        species: "Human",
        gender: .male,
        origin: Character.Location(name: "unknown", url: ""),
        location: Character.Location(name: "Citadel of Ricks", url: "https://rickandmortyapi.com/api/location/3"),
        image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg",
        episode: [
            "https://rickandmortyapi.com/api/episode/1"
        ]
    )
    
    // MARK: - Sample Page
    
    static let samplePage = CharacterPage(
        info: CharacterPage.PageInfo(
            count: 826,
            pages: 42,
            next: "https://rickandmortyapi.com/api/character?page=2",
            prev: nil
        ),
        results: [sampleCharacter, sampleCharacter2]
    )
    
    static let samplePageNoMore = CharacterPage(
        info: CharacterPage.PageInfo(
            count: 2,
            pages: 1,
            next: nil,
            prev: nil
        ),
        results: [sampleCharacter, sampleCharacter2]
    )
    
    static let emptyPage = CharacterPage(
        info: CharacterPage.PageInfo(
            count: 0,
            pages: 0,
            next: nil,
            prev: nil
        ),
        results: []
    )
    
    // MARK: - JSON Data
    
    static let validCharacterPageJSON = """
    {
        "info": {
            "count": 826,
            "pages": 42,
            "next": "https://rickandmortyapi.com/api/character?page=2",
            "prev": null
        },
        "results": [
            {
                "id": 1,
                "name": "Rick Sanchez",
                "status": "Alive",
                "species": "Human",
                "gender": "Male",
                "origin": {
                    "name": "Earth (C-137)",
                    "url": "https://rickandmortyapi.com/api/location/1"
                },
                "location": {
                    "name": "Citadel of Ricks",
                    "url": "https://rickandmortyapi.com/api/location/3"
                },
                "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                "episode": [
                    "https://rickandmortyapi.com/api/episode/1"
                ]
            }
        ]
    }
    """.data(using: .utf8)!
    
    static let validCharacterJSON = """
    {
        "id": 1,
        "name": "Rick Sanchez",
        "status": "Alive",
        "species": "Human",
        "gender": "Male",
        "origin": {
            "name": "Earth (C-137)",
            "url": "https://rickandmortyapi.com/api/location/1"
        },
        "location": {
            "name": "Citadel of Ricks",
            "url": "https://rickandmortyapi.com/api/location/3"
        },
        "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
        "episode": [
            "https://rickandmortyapi.com/api/episode/1"
        ]
    }
    """.data(using: .utf8)!
    
    static let invalidJSON = "{ invalid json }".data(using: .utf8)!
}
