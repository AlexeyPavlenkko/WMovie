//
//  APIRequests.swift
//  WMovie
//
//  Created by Алексей Павленко on 29.09.2022.
//

import Foundation

/*
"Trending Movies"
"Popular"
"Trending TV"
"Upcoming Movies"
"Top Rated"
 */

struct TrendingMoviesRequest: APIRequest {
    typealias Response = [Movie]
    
    var path: String { "/3/trending/movie/day" }
}

struct TrendingTVsRequest: APIRequest {
    typealias Response = [Movie]
    
    var path: String { "/3/trending/tv/day" }
}

struct PopularMoviesRequest: APIRequest {
    typealias Response = [Movie]
    
    var path: String { "/3/movie/popular" }
}

struct PopularTVsRequest: APIRequest {
    typealias Response = [Movie]
    
    var path: String { "/3/tv/popular"}
}

struct TopRatedMoviesRequest: APIRequest {
    typealias Response = [Movie]
    
    var path: String { "/3/movie/top_rated" }
}

struct TopRatedTVsRequest: APIRequest {
    typealias Response = [Movie]
    
    var path: String { "/3/tv/top_rated"}
}

struct UpcomingMoviesRequest: APIRequest {
    typealias Response = [Movie]
    
    var path: String { "/3/movie/upcoming" }
    
    let page: Int
    
    var queryItems: [URLQueryItem]? { [URLQueryItem(name: "api_key", value: APIConstants.API_KEY), URLQueryItem(name: "page", value: "\(page)")] }
    
    init(page: Int) {
        self.page = page
    }
}

struct SearchMovieRequest: APIRequest {
    typealias Response = [Movie]
    //, URLQueryItem(name: "language", value: "en-US")
    var path: String { "/3/search/movie" }
    
    var queryItems: [URLQueryItem]? { [URLQueryItem(name: "api_key", value: APIConstants.API_KEY), URLQueryItem(name: "page", value: "1"), URLQueryItem(name: "include_adult", value: "true"), URLQueryItem(name: "query", value: query)] }
    
    let query: String
    
    init(query: String) {
        self.query = query
    }
}

struct SearchTVsRequest: APIRequest {
    typealias Response = [Movie]
    //, URLQueryItem(name: "language", value: "en-US")
    var path: String { "/3/search/tv" }
    
    var queryItems: [URLQueryItem]? { [URLQueryItem(name: "api_key", value: APIConstants.API_KEY), URLQueryItem(name: "page", value: "1"), URLQueryItem(name: "include_adult", value: "true"), URLQueryItem(name: "query", value: query)] }
    
    let query: String
    
    init(query: String) {
        self.query = query
    }
}
