//
//  CharacterDetailViewState.swift
//  RickyMortyApp
//
//  Created by Angel Tejedor on 14/01/26.
//

import Foundation

enum CharacterDetailViewState: Equatable {
    case loading
    case loaded(Character)
    case error(String)
}
