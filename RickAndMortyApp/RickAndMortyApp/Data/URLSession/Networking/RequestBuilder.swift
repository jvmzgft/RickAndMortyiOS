//
//  RequestBuilder.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import Foundation

struct RequestBuilder {

    func makeRequest(from endpoint: APIRequest) throws -> URLRequest {
        var components = URLComponents()
        components.scheme = EnvironmentConstants.scheme
        components.host = EnvironmentConstants.baseURL
        components.path = endpoint.path
        
        if !endpoint.queryItems.isEmpty {
            components.queryItems = endpoint.queryItems
        }

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        if endpoint.method != .get {
            request.httpBody = endpoint.body
        }

        if let contentType = endpoint.contentType {
            request.setValue(contentType.headerValue, forHTTPHeaderField: "Content-Type")
        }

        if let acceptType = endpoint.acceptType {
            request.setValue(acceptType.headerValue, forHTTPHeaderField: "Accept")
        }

        endpoint.headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }
}
