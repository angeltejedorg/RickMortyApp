//
//  APIClient.swift
//  RickyMortyApp
//
//  Created by Angel Tejedor on 14/01/26.
//

import Foundation

protocol APIClientProtocol {
    func fetch<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

final class APIClient: APIClientProtocol {

    private let session: URLSessionProtocol
    private let logger: Logger
    
    init(session: URLSessionProtocol = URLSession.shared, logger: Logger = ConsoleLogger.shared) {
        self.session = session
        self.logger = logger
    }
    
    func fetch<T>(_ endpoint: Endpoint) async throws -> T where T : Decodable {
        guard let url = endpoint.url else {
            let error = APIError.networkError("Invalid URL")
            logger.error(error.logDescription, error: error, context: nil)
            throw error
        }
        
        logger.debug("Fetching: \(url.absoluteString)")
        
        let request = URLRequest(url: url)
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let error = APIError.networkError("Invalid response type")
                logger.error(error.logDescription, error: error, context: nil)
                throw error
            }
            
            logger.debug("Response: \(httpResponse.statusCode) for \(url.absoluteString)")
            
            switch httpResponse.statusCode {
            case 200...299:
                do {
                    return try JSONDecoder().decode(T.self, from: data)
                } catch let decodingError {
                    let error = APIError.decodingError(decodingError.localizedDescription)
                    logger.error(error.logDescription, error: decodingError, context: [
                        "url": url.absoluteString,
                        "type": String(describing: T.self)
                    ])
                    throw error
                }
            case 404:
                let error = APIError.notFound
                logger.info("Resource not found: \(url.absoluteString)")
                throw error
            default:
                let error = APIError.unknown(statusCode: httpResponse.statusCode)
                logger.error(error.logDescription, error: nil, context: [
                    "url": url.absoluteString,
                    "statusCode": httpResponse.statusCode
                ])
                throw error
            }
        } catch let urlError as URLError {
            let error = APIError.networkError(urlError.localizedDescription)
            logger.error(error.logDescription, error: urlError, context: [
                "url": url.absoluteString,
                "errorCode": urlError.code.rawValue
            ])
            throw error
        } catch let apiError as APIError {
            throw apiError
        } catch {
            let apiError = APIError.networkError(error.localizedDescription)
            logger.error("Unexpected error", error: error, context: ["url": url.absoluteString])
            throw error
        }
    }
    
}
