//
//  RequestBuilderTests.swift
//  RickAndMortyAppTests
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import XCTest
@testable import RickAndMortyApp

@MainActor
final class RequestBuilderTests: XCTestCase {
    func testBuildsCharacterListURLWithQueryItems() throws {
        let builder = RequestBuilder()
        let request = try builder.makeRequest(
            from: RickAndMortyAPI.characterList(page: 2, name: "rick")
        )

        guard let url = request.url, let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            XCTFail("Missing URL components")
            return
        }

        XCTAssertEqual(components.scheme, "https")
        XCTAssertEqual(components.host, "rickandmortyapi.com")
        XCTAssertEqual(components.path, "/api/character")
        let items = components.queryItems ?? []
        XCTAssertTrue(items.contains(URLQueryItem(name: "page", value: "2")))
        XCTAssertTrue(items.contains(URLQueryItem(name: "name", value: "rick")))
    }

    func testHeadersAndBodyRespectMethod() throws {
        let builder = RequestBuilder()
        let request = try builder.makeRequest(from: TestRequest())

        XCTAssertEqual(request.httpMethod, HTTPMethod.post.rawValue)
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Accept"), "text/plain")
        XCTAssertEqual(request.value(forHTTPHeaderField: "X-Test"), "1")
        XCTAssertEqual(request.httpBody, Data("hello".utf8))

        let getRequest = try builder.makeRequest(from: TestRequest(method: .get))
        XCTAssertNil(getRequest.httpBody)
    }
}

private struct TestRequest: APIRequest {
    var path: String = "/test"
    var method: HTTPMethod = .post
    var queryItems: [URLQueryItem] = []
    var contentType: MediaType? = .json
    var acceptType: MediaType? = .plainText
    var headers: [String: String] = ["X-Test": "1"]
    var body: Data? = Data("hello".utf8)
}
