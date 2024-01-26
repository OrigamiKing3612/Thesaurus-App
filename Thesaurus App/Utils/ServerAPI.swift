//
//  ServerAPI.swift
//  Thesaurus App
//
//  Created by Malachi on 1/25/24.
//

import Foundation

public class ServerAPI {
    public static let shared = ServerAPI()
        
    @discardableResult
    public func fetch(word: String) async -> Word? {
        #if DEBUG
        return Word(word: "Good", synonyms: mockSyn(), antonyms: mockAyn())
        #else
        guard let url = URL(string: "https://api.api-ninjas.com/v1/thesaurus?word=" + word.lowercased()) else {
            print("invalidUrl")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Key", forHTTPHeaderField: "X-Api-Key")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("error")
                return nil
            }
            
            return try JSONDecoder().decode(Word.self, from: data)
        } catch {
            print("error")
            return nil
        }
        #endif
    }
    private init() {}
}

extension URLRequest {
    public func fetch() async throws -> Data? {
        do {
            let (data, response) = try await URLSession.shared.data(for: self)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw NetworkError.error
            }
            return data
        } catch {
            throw NetworkError.unknownError
        }
    }
}

extension URL {
    public func fetch() async throws -> Data? {
        try await URLRequest(url: self).fetch()
    }
}

extension String {
    public var url: URL? { URL(string: self) }
}

public struct Word: Codable {
    public let word: String
    public let synonyms: [String]
    public let antonyms: [String]
}

public enum NetworkError: Error {
    case unknownError
    case error
    case invalidUrl
}
