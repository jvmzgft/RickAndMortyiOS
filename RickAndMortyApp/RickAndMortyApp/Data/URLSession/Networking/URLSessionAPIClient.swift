//
//  URLSessionAPIClient.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import Foundation

final class URLSessionAPIClient: APIClient {
    private let session: URLSession
    private let requestBuilder: RequestBuilder

    init(session: URLSession = .shared) {
        self.session = session
        self.requestBuilder = RequestBuilder()
    }

    func send<T: Decodable>(_ endpoint: APIRequest) async throws -> T {
        let request = try requestBuilder.makeRequest(from: endpoint)

        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.statusCode(httpResponse.statusCode)
            }

            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw NetworkError.decoding(error)
            }
        } catch {
            throw NetworkError.transport(error)
        }
    }
}
