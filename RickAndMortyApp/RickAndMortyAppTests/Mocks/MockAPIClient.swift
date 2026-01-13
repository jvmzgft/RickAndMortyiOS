//
//  MockAPIClient.swift
//  RickAndMortyAppTests
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import Foundation
@testable import RickAndMortyApp

final class MockAPIClient: APIClient {
    enum MockError: Error {
        case emptyQueue
        case typeMismatch
    }

    struct RequestRecord {
        let path: String
        let queryItems: [URLQueryItem]
        let method: HTTPMethod
    }

    private(set) var requests: [RequestRecord] = []
    private var responses: [Result<Any, Error>] = []

    func enqueue(_ error: Error) {
        responses.append(.failure(error))
    }

    func enqueue<T>(_ result: Result<T, Error>) {
        responses.append(result.map { $0 as Any })
    }

    func send<T: Decodable>(_ endpoint: APIRequest) async throws -> T {
        requests.append(
            RequestRecord(path: endpoint.path, queryItems: endpoint.queryItems, method: endpoint.method)
        )

        guard !responses.isEmpty else {
            throw MockError.emptyQueue
        }

        let result = responses.removeFirst()
        switch result {
        case let .success(value):
            guard let typed = value as? T else {
                throw MockError.typeMismatch
            }
            return typed
        case let .failure(error):
            throw error
        }
    }
}
