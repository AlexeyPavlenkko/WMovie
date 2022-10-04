//
//  SearchViewModel.swift
//  WMovie
//
//  Created by Алексей Павленко on 30.09.2022.
//

import Foundation

protocol SearchViewModelProtocol: AnyObject {
    func getSeachScopeTitles() -> [String]
    func searchWithQuery(_ query: String, forScopeAtIndex index: Int)
    func getMovieForCell(at index: Int) -> Movie
    func getNumberOfRows() -> Int
    func isMovieAlreadySavedCheck(_ movie: Movie) -> Bool
    func toggleStorageStatusFor(_ movie: Movie) -> String
    var moviesFound: (() -> Void)? { get set }
    var noMoviesExist: (() -> Void)? { get set }
    var failedToFoundMovies: ((String) -> Void)? { get set }
}

final class SearchViewModel: SearchViewModelProtocol {
    
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
    
    func toggleStorageStatusFor(_ movie: Movie) -> String {
        let isAlreadySaved = isMovieAlreadySavedCheck(movie)
        switch isAlreadySaved {
        case false:
            let isSaved = CoreDataManager.shared.saveMovie(movie)
            return isSaved ? "📦 Saved!" : "⛔️ Could not be saved. Please try again later."
        case true:
            let isDeleted = CoreDataManager.shared.deleteMovie(movie)
            return isDeleted ? "🗑 Deleted" : "⛔️ Could not be deleted. Please try again later."
        }
    }
    
    func isMovieAlreadySavedCheck(_ movie: Movie) -> Bool {
        return CoreDataManager.shared.checkIfMovieIsSaved(movie)
    }
    
    //MARK: - Deinit
    deinit { print("DEALLOCATION: \(Self.self)")}
}
