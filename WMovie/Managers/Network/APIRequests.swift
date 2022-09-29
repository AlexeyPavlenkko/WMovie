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

struct UpcomingMoviesRequest: APIRequest {
    typealias Response = [Movie]
    
    var path: String { "/3/movie/upcoming" }
}

struct TopRatedMoviesRequest: APIRequest {
    typealias Response = [Movie]
    
    var path: String { "/3/movie/top_rated" }
}
