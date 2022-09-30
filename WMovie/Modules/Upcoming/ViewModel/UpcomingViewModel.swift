//
//  UpcomingViewModel.swift
//  WMovie
//
//  Created by Алексей Павленко on 29.09.2022.
//

import Foundation

protocol UpcomingViewModelProtocol {
    var moviesLoaded: (() -> Void)? { get set }
    var loadingFailed: ((String) -> Void)? { get set }
    func getNumberOfRows() -> Int
    func didSelectMovie(at index: Int)
    func getMovieForCell(at index: Int) -> Movie
    func loadMoreMovies()
    
}

class UpcomingViewModel: UpcomingViewModelProtocol {
    
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
    
    func didSelectMovie(at index: Int) {
        let movie = upcomingMovies[index]
        print(movie)
    }
    
}
