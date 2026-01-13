//
//  APIClient.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import Foundation

protocol APIClient {
    func send<T: Decodable>(_ endpoint: APIRequest) async throws -> T
}
