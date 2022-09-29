//
//  HomeViewModel.swift
//  WMovie
//
//  Created by Алексей Павленко on 29.09.2022.
//

import Foundation

protocol HomeViewModelProtocol: AnyObject {
    func viewDidLoaded()
    func getNumberOfSections() -> Int
    func getNumberOfItemsForSection(at index: Int) -> Int
    func getHeaderTitleForSection(at index: Int) -> String
    func getMovieForCell(at indexPath: IndexPath) -> Movie
    var allMoviesLoaded: (() -> Void)? { get set }
}

class HomeViewModel: HomeViewModelProtocol {
    
    //MARK: - Private
    private enum Sections: String, CaseIterable {
        case mainHeader     = ""
        case trendingMovies = "Trending Movies"
        case trendingTV     = "Trending TV"
        case popular        = "Popular"
        case upcomingMovies = "Upcoming Movies"
        case topRated       = "Top Rated"
    }
    
    private let dispatchGroup = DispatchGroup()
    
    private var trendingMovies: [Movie] = []
    private var popularMovies: [Movie] = []
    private var trendingTVs: [Movie] = []
    private var upcomingMovies: [Movie] = []
    private var topRatedMovies: [Movie] = []
    
    //private let router: Router
    
    //MARK: - Public
    var allMoviesLoaded: (() -> Void)?
    
    func viewDidLoaded() {
        CacheManager.shared.restoreCache()
        
        dispatchGroup.enter()
        NetworkManager.shared.send(request: TrendingMoviesRequest()) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.trendingMovies = movies
                print("-----trendingMovies GOT")
            case .failure(let error):
                print(error)
            }
            self?.dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        NetworkManager.shared.send(request: PopularMoviesRequest()) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.popularMovies = movies
                print("-----popularMovies GOT")
            case .failure(let error):
                print(error)
            }
            self?.dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        NetworkManager.shared.send(request: TrendingTVsRequest()) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.trendingTVs = movies
                print("-----trendingTVs GOT")
            case .failure(let error):
                print(error)
            }
            self?.dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        NetworkManager.shared.send(request: UpcomingMoviesRequest()) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.upcomingMovies = movies
                print("-----upcomingMovies GOT")
            case .failure(let error):
                print(error)
            }
            self?.dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        NetworkManager.shared.send(request: TopRatedMoviesRequest()) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.topRatedMovies = movies
                print("-----topRatedMovies GOT")
            case .failure(let error):
                print(error)
            }
            self?.dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            print("NOTIFY CALLED")
            self?.allMoviesLoaded?()
        }
        
    }
    
    func getNumberOfSections() -> Int {
        return Sections.allCases.count
    }
    
    func getNumberOfItemsForSection(at index: Int) -> Int {
        let section = Sections.allCases[index]
        switch section {
        case .mainHeader:     return 1
        case .trendingMovies: return trendingMovies.count
        case .popular:        return popularMovies.count
        case .trendingTV:     return trendingTVs.count
        case .upcomingMovies: return upcomingMovies.count
        case .topRated:       return topRatedMovies.count
        }
    }
    
    func getHeaderTitleForSection(at index: Int) -> String {
        return Sections.allCases[index].rawValue
    }
    
    func getMovieForCell(at indexPath: IndexPath) -> Movie {
        let section = Sections.allCases[indexPath.section]
        switch section {
        case .mainHeader:
            if !trendingMovies.isEmpty {
                return trendingMovies[0]
            }
            return Movie()
        case .trendingMovies:
            return trendingMovies[indexPath.row]
        case .popular:
            return popularMovies[indexPath.row]
        case .trendingTV:
            return trendingTVs[indexPath.row]
        case .upcomingMovies:
            return upcomingMovies[indexPath.row]
        case .topRated:
            return topRatedMovies[indexPath.row]
        }
    }
    
    func didSelectMovie(at indexPath: IndexPath) {
        
    }
}
