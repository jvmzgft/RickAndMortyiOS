//
//  APIRequest.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import Foundation

protocol APIRequest {
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
    var contentType: MediaType? { get }
    var acceptType: MediaType? { get }
    var headers: [String: String] { get }
    var body: Data? { get }
}

extension APIRequest {
    var method: HTTPMethod { .get }
    var queryItems: [URLQueryItem] { [] }
    var contentType: MediaType? { nil }
    var acceptType: MediaType? { nil }
    var headers: [String: String] { [:] }
    var body: Data? { nil }
}
