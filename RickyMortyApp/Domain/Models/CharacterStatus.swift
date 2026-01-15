//
//  CharacterStatus.swift
//  RickyMortyApp
//
//  Created by Angel Tejedor on 14/01/26.
//

import Foundation

enum CharacterStatus: String, Codable, CaseIterable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}
