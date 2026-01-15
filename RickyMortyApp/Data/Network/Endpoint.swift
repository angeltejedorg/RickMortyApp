//
//  Endpoint.swift
//  RickyMortyApp
//
//  Created by Angel Tejedor on 14/01/26.
//

import Foundation

enum Endpoint {
    case characterList(page: Int, name: String?, status: CharacterStatus?)
    case characterDetail(id: Int)
    
    private var baseURL: String {"https://rickandmortyapi.com/api"}
    
    var url: URL? {
        switch self {
        case .characterList(let page, let name, let status):
            var components = URLComponents(string: "\(baseURL)/character")
            var queryItems = [URLQueryItem(name: "page", value: "\(page)")]
            if let name, !name.isEmpty {
                queryItems.append(URLQueryItem(name: "name", value: name))
            }
            if let status {
                queryItems.append(URLQueryItem(name: "status", value: status.rawValue.lowercased()))
            }
            
            components?.queryItems = queryItems
            return components?.url
        case .characterDetail(let id):
            return URL(string: "\(baseURL)/character/\(id)")
        }
    }
}
