//
//  URLSessionProtocol.swift
//  RickyMortyApp
//
//  Created by Angel Tejedor on 14/01/26.
//

import Foundation

protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {} //Why this?

