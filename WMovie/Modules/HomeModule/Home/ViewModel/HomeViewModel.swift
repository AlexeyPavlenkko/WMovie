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
    var loadingFailed: ((String) -> Void)? { get set }
}

class HomeViewModel: HomeViewModelProtocol {
    
    //MARK: - Private
    private enum Sections: String, CaseIterable {
        case mainHeader     = ""
        case trendingMovies = "Trending Movies"
        case trendingTV     = "Trending TV shows"
        case popularMovies  = "Popular Movies"
        case popularTV      = "Popular TV shows"
        case topRatedMovies = "Top Rated Movies"
        case topRatedTVs    = "Top Rated TV shows"
    }
    
    private let dispatchGroup = DispatchGroup()
    
    private var trendingMovies: [Movie] = []
    private var trendingTVs: [Movie] = []
    private var popularMovies: [Movie] = []
    private var popularTVs: [Movie] = []
    private var topRatedMovies: [Movie] = []
    private var topRatedTVs: [Movie] = []
    
    private var errorMessages = ""
    
    //MARK: - Public
    var allMoviesLoaded: (() -> Void)?
    var loadingFailed: ((String) -> Void)?
    
    func viewDidLoaded() {
        CacheManager.shared.restoreCache()
        
        dispatchGroup.enter()
        NetworkManager.shared.send(request: TrendingMoviesRequest()) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.trendingMovies = movies
                print("-----trendingMovies GOT")
            case .failure(let error):
                self?.errorMessages += "\(error.localizedDescription), "
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
                self?.errorMessages += "\(error.localizedDescription), "
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
                self?.errorMessages += "\(error.localizedDescription), "
            }
            self?.dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        NetworkManager.shared.send(request: PopularTVsRequest()) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.popularTVs = movies
                print("-----popularTVs GOT")
            case .failure(let error):
                self?.errorMessages += "\(error.localizedDescription), "
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
                self?.errorMessages += "\(error.localizedDescription), "
            }
            self?.dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        NetworkManager.shared.send(request: TopRatedTVsRequest()) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.topRatedTVs = movies
                print("-----topRatedMovies GOT")
            case .failure(let error):
                self?.errorMessages += "\(error.localizedDescription), "
            }
            self?.dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            print("NOTIFY CALLED")
            guard let self = self else {return}
            if self.errorMessages.isEmpty {
                self.allMoviesLoaded?()
            } else {
                self.loadingFailed?(self.errorMessages)
            }
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
        case .trendingTV:     return trendingTVs.count
        case .popularMovies:  return popularMovies.count
        case .popularTV:      return popularTVs.count
        case .topRatedMovies: return topRatedMovies.count
        case .topRatedTVs:    return topRatedTVs.count
        }
    }
    
    func getHeaderTitleForSection(at index: Int) -> String {
        return Sections.allCases[index].rawValue
    }
    
    func getMovieForCell(at indexPath: IndexPath) -> Movie {
        let section = Sections.allCases[indexPath.section]
        switch section {
        case .mainHeader:     return trendingMovies.isEmpty == false ? trendingMovies[0] : Movie()
        case .trendingMovies: return trendingMovies[indexPath.row]
        case .trendingTV:     return trendingTVs[indexPath.row]
        case .popularMovies:  return popularMovies[indexPath.row]
        case .popularTV:      return popularTVs[indexPath.row]
        case .topRatedMovies: return topRatedMovies[indexPath.row]
        case .topRatedTVs:    return topRatedTVs[indexPath.row]
        }
    }
}
