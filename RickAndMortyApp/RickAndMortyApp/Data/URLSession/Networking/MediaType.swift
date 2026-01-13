//
//  MediaType.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import Foundation

enum MediaType {
    case json
    case formURLEncoded
    case multipart(boundary: String)
    case plainText
    case custom(String)

    var headerValue: String {
        switch self {
        case .json:
            return "application/json"
        case .formURLEncoded:
            return "application/x-www-form-urlencoded"
        case let .multipart(boundary):
            return "multipart/form-data; boundary=\(boundary)"
        case .plainText:
            return "text/plain"
        case let .custom(value):
            return value
        }
    }
}
