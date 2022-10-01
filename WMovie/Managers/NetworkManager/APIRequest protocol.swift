//
//  APIRequest.swift
//  WMovie
//
//  Created by Алексей Павленко on 29.09.2022.
//

import Foundation

fileprivate struct APIRespone<T: Decodable>: Decodable {
    let results: T
}

protocol APIRequest {
    associatedtype Response: Decodable
    
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var requestURL: URLRequest? { get }
    var postData: Data? { get }
    func decode(from data: Data) throws -> Response
}

extension APIRequest {
    var queryItems: [URLQueryItem]? { [URLQueryItem(name: "api_key", value: APIConstants.tmdbAPI_KEY), URLQueryItem(name: "page", value: "1")] }

    var postData: Data? { nil }
    
    var requestURL: URLRequest? {
        guard var components = URLComponents(string: APIConstants.tmdbBaseURL) else { return nil }
        components.path = path
        components.queryItems = queryItems
        guard let url = components.url else { return nil }
        var request = URLRequest(url: url)
        
        if let data = postData {
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
        }
        
        return request
    }
    
    func decode(from data: Data) throws -> Response {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let jsondecoder = JSONDecoder()
        jsondecoder.dateDecodingStrategy = .formatted(dateFormatter)
        let decodedResponse = try jsondecoder.decode(APIRespone<Response>.self, from: data)
        return decodedResponse.results
    }
}
