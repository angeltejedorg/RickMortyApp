//
//  MockURLSession.swift
//  RickyMortyAppTests
//
//  Created by Angel Tejedor on 15/01/26.
//

import Foundation
@testable import RickyMortyApp

final class MockURLSession: URLSessionProtocol {
    
    var data: Data
    var statusCode: Int
    var error: Error?
    
    init(data: Data = Data(), statusCode: Int = 200, error: Error? = nil) {
        self.data = data
        self.statusCode = statusCode
        self.error = error
    }
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        
        let response = HTTPURLResponse(
            url: request.url!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
        
        return (data, response)
    }
}
