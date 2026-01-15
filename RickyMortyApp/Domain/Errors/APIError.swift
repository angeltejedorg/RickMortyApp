//
//  APIError.swift
//  RickyMortyApp
//
//  Created by Angel Tejedor on 14/01/26.
//

import Foundation

enum APIError: Error, Equatable {
    
    case networkError(String?)
    case decodingError(String)
    case notFound
    case unknown(statusCode: Int)
    
    var userMessage: String {
        switch self {
        case .networkError:
            return "Couldn't connect. Check your internet and try again."
        case .decodingError:
            return "Something went wrong. Please try again later."
        case .notFound:
            return "No characters found."
        case .unknown:
            return "Something went wrong. Please try again"
        }
    }
    
    var logDescription: String {
        switch self {
        case .networkError(let description):
            return "NetworkError: \(description ?? "unknown")"
        case .decodingError(let context):
            return "DecodigError: \(context)"
        case .notFound:
            return "NotFound: 404 response"
        case .unknown(let statusCode):
            return "UnknownError: HTTP \(statusCode)"
        }
    }
}
