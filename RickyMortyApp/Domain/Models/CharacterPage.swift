//
//  CharacterPage.swift
//  RickyMortyApp
//
//  Created by Angel Tejedor on 14/01/26.
//

import Foundation

struct CharacterPage: Codable {
    let info: PageInfo
    let results: [Character]
    
    struct PageInfo: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
}
