//
//  UpcomingViewModel.swift
//  WMovie
//
//  Created by Алексей Павленко on 29.09.2022.
//

import Foundation

protocol UpcomingViewModelProtocol: AnyObject {
    var moviesLoaded: (() -> Void)? { get set }
    var loadingFailed: ((String) -> Void)? { get set }
    func getNumberOfRows() -> Int
    func getMovieForCell(at index: Int) -> Movie
    func loadMoreMovies()
    func isMovieAlreadySavedCheck(_ movie: Movie) -> Bool
    func toggleStorageStatusFor(_ movie: Movie) -> String
}

final class UpcomingViewModel: UpcomingViewModelProtocol {
    
    //MARK: - Private
    private var upcomingMovies: [Movie] = []
    private var page: Int = 0
    
    //MARK: - Public
    var moviesLoaded: (() -> Void)?
    var loadingFailed: ((String) -> Void)?
    
    func loadMoreMovies() {
        page += 1
        NetworkManager.shared.send(request: UpcomingMoviesRequest(page: page)) { [weak self] result in
            switch result {
            case .success(let movies):
                let filteredMovies = movies.filter { $0.year >= .now }
                self?.upcomingMovies += filteredMovies.sorted { $0.year < $1.year }
                DispatchQueue.main.async {
                    self?.moviesLoaded?()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.loadingFailed?(error.localizedDescription)
                }
            }
        }
    }
    
    func getNumberOfRows() -> Int {
        return upcomingMovies.count
    }
    
    func getMovieForCell(at index: Int) -> Movie {
        return upcomingMovies[index]
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
