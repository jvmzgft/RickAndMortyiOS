//
//  DependencyInjector.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import Foundation

internal class DependencyInjector {
    static func getURLSessionAPIClient() -> URLSessionAPIClient {
        URLSessionAPIClient()
    }
}
