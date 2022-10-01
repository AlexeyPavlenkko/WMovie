//
//  SearchViewModel.swift
//  WMovie
//
//  Created by Алексей Павленко on 30.09.2022.
//

import Foundation

protocol SearchViewModelProtocol {
    func getSeachScopeTitles() -> [String]
    func searchWithQuery(_ query: String, forScopeAtIndex index: Int)
    func getMovieForCell(at index: Int) -> Movie
    func getNumberOfRows() -> Int
    var moviesFound: (() -> Void)? { get set }
    var noMoviesExist: (() -> Void)? { get set }
    var failedToFoundMovies: ((String) -> Void)? { get set }
}

class SearchViewModel: SearchViewModelProtocol {
    
    //MARK: - Private
    private enum SearchScope: String, CaseIterable {
        case movies  = "Movie"
        case tvShows = "TV show"
    }
    
    private var movies: [Movie] = []
    
    //MARK: - Public
    var moviesFound: (() -> Void)?
    var noMoviesExist: (() -> Void)?
    var failedToFoundMovies: ((String) -> Void)?
    
    
    func getSeachScopeTitles() -> [String] {
        return SearchScope.allCases.map { $0.rawValue }
    }
    
    func searchWithQuery(_ query: String, forScopeAtIndex index: Int) {
        guard !query.isEmpty else {
            self.movies = []
            DispatchQueue.main.async { [weak self] in
                self?.noMoviesExist?()
            }
            return
        }
        
        let scope = SearchScope.allCases[index]
        switch scope {
        case .movies:
            NetworkManager.shared.send(request: SearchMovieRequest(query: query)) { [weak self] result in
                switch result {
                case .success(let movies):
                    self?.movies = movies.sorted { $0.year > $1.year }
                    if movies.isEmpty {
                        DispatchQueue.main.async {
                            self?.noMoviesExist?()
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.moviesFound?()
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.failedToFoundMovies?(error.localizedDescription)
                    }
                }
            }
        case .tvShows:
            NetworkManager.shared.send(request: SearchTVsRequest(query: query)) { [weak self] result in
                switch result {
                case .success(let movies):
                    self?.movies = movies.sorted { $0.year > $1.year }
                    if movies.isEmpty {
                        DispatchQueue.main.async {
                            self?.noMoviesExist?()
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.moviesFound?()
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.failedToFoundMovies?(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func getNumberOfRows() -> Int {
        return movies.count
    }
    
    func getMovieForCell(at index: Int) -> Movie {
        return movies[index]
    }
}
