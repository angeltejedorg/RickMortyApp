//
//  CharacterListViewState.swift
//  RickyMortyApp
//
//  Created by Angel Tejedor on 14/01/26.
//

import Foundation

enum CharacterListViewState: Equatable {
    case idle
    case loading
    case loaded(characters: [Character], canLoadMore: Bool)
    case empty
    case error(String)
}

enum StatusFilter: String, CaseIterable {
    case all = "All"
    case alive = "Alive"
    case dead = "Dead"
    case uknwon = "Unknown"
    
    var apiStatus: CharacterStatus? {
        switch self {
        case .all:
            return nil
        case .alive:
            return .alive
        case .dead:
            return .dead
        case .uknwon:
            return .unknown
        }
    }
}
