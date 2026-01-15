//
//  APIClientTests.swift
//  RickyMortyAppTests
//
//  Created by Angel Tejedor on 15/01/26.
//

import XCTest
@testable import RickyMortyApp

final class APIClientTests: XCTestCase {
    
    // MARK: - Success Tests
    
    func test_fetchCharacterPage_success_decodesCorrectly() async throws {
        // Given
        let mockSession = MockURLSession(data: TestData.validCharacterPageJSON, statusCode: 200)
        let sut = APIClient(session: mockSession)
        
        // When
        let page: CharacterPage = try await sut.fetch(.characterList(page: 1, name: nil, status: nil))
        
        // Then
        XCTAssertEqual(page.info.count, 826)
        XCTAssertEqual(page.info.pages, 42)
        XCTAssertEqual(page.results.count, 1)
        XCTAssertEqual(page.results.first?.name, "Rick Sanchez")
        XCTAssertEqual(page.results.first?.status, .alive)
    }
    
    func test_fetchCharacter_success_decodesCorrectly() async throws {
        // Given
        let mockSession = MockURLSession(data: TestData.validCharacterJSON, statusCode: 200)
        let sut = APIClient(session: mockSession)
        
        // When
        let character: Character = try await sut.fetch(.characterDetail(id: 1))
        
        // Then
        XCTAssertEqual(character.id, 1)
        XCTAssertEqual(character.name, "Rick Sanchez")
        XCTAssertEqual(character.species, "Human")
        XCTAssertEqual(character.gender, .male)
    }
    
    // MARK: - Error Tests
    
    func test_fetch_404Response_throwsNotFoundError() async {
        // Given
        let mockSession = MockURLSession(data: Data(), statusCode: 404)
        let sut = APIClient(session: mockSession)
        
        // When/Then
        do {
            let _: CharacterPage = try await sut.fetch(.characterList(page: 1, name: "nonexistent", status: nil))
            XCTFail("Expected notFound error")
        } catch let error as APIError {
            XCTAssertEqual(error, .notFound)
        } catch {
            XCTFail("Expected APIError, got \(error)")
        }
    }
    
    func test_fetch_500Response_throwsUnknownError() async {
        // Given
        let mockSession = MockURLSession(data: Data(), statusCode: 500)
        let sut = APIClient(session: mockSession)
        
        // When/Then
        do {
            let _: CharacterPage = try await sut.fetch(.characterList(page: 1, name: nil, status: nil))
            XCTFail("Expected unknown error")
        } catch let error as APIError {
            XCTAssertEqual(error, .unknown(statusCode: 500))
        } catch {
            XCTFail("Expected APIError, got \(error)")
        }
    }
    
    func test_fetch_invalidJSON_throwsDecodingError() async {
        // Given
        let mockSession = MockURLSession(data: TestData.invalidJSON, statusCode: 200)
        let sut = APIClient(session: mockSession)
        
        // When/Then
        do {
            let _: CharacterPage = try await sut.fetch(.characterList(page: 1, name: nil, status: nil))
            XCTFail("Expected decoding error")
        } catch let error as APIError {
            if case .decodingError = error {
                // Success
            } else {
                XCTFail("Expected decodingError, got \(error)")
            }
        } catch {
            XCTFail("Expected APIError, got \(error)")
        }
    }
    
    func test_fetch_networkError_throwsNetworkError() async {
        // Given
        let urlError = URLError(.notConnectedToInternet)
        let mockSession = MockURLSession(data: Data(), statusCode: 200, error: urlError)
        let sut = APIClient(session: mockSession)
        
        // When/Then
        do {
            let _: CharacterPage = try await sut.fetch(.characterList(page: 1, name: nil, status: nil))
            XCTFail("Expected network error")
        } catch let error as APIError {
            if case .networkError = error {
                // Success
            } else {
                XCTFail("Expected networkError, got \(error)")
            }
        } catch {
            XCTFail("Expected APIError, got \(error)")
        }
    }
    
}
