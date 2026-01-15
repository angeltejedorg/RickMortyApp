//
//  Character.swift
//  RickyMortyApp
//
//  Created by Angel Tejedor on 14/01/26.
//

import Foundation

struct Character: Codable, Identifiable, Equatable, Hashable {
    
    let id: Int
    let name: String
    let status: CharacterStatus
    let species: String
    let gender: CharacterGender
    let origin: Location
    let location: Location
    let image: String
    let episode: [String]
    
    struct Location: Codable, Equatable, Hashable {
        let name: String
        let url: String
    }
}
