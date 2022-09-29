//
//  APIRequest.swift
//  WMovie
//
//  Created by Алексей Павленко on 29.09.2022.
//

import Foundation

fileprivate struct APIConstants {
    static let API_KEY = "87db726043635956ebb8cde640e28a2f"
    static let baseURL = "https://api.themoviedb.org"
}

fileprivate struct APIRespone<T: Decodable>: Decodable {
    let results: T
    
}

protocol APIRequest {
    associatedtype Response: Decodable
    
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var requestURL: URL? { get }
    func decode(from data: Data) throws -> Response
}

extension APIRequest {
    var queryItems: [URLQueryItem]? { [URLQueryItem(name: "api_key", value: APIConstants.API_KEY)] }

    var requestURL: URL? {
        guard var components = URLComponents(string: APIConstants.baseURL) else { return nil }
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
    
    func decode(from data: Data) throws -> Response {
        let decodedResponse = try JSONDecoder().decode(APIRespone<Response>.self, from: data)
        return decodedResponse.results
    }
}
