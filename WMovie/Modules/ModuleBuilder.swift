//
//  ModuleBuilder.swift
//  WMovie
//
//  Created by Алексей Павленко on 04.10.2022.
//

import UIKit

enum AppsModule {
    case home
    case upcoming
    case search
    case downloads
    case movieDetail(movie: Movie, isButtonHidden: Bool = false)
}

protocol ModuleBuilderProtocol: AnyObject  {
    func build(module: AppsModule) -> UIViewController
}

final class AppModuleBuilder: ModuleBuilderProtocol {
    
    //MARK: Public methods
    func build(module: AppsModule) -> UIViewController {
        switch module {
        case .home:
            return buildHomeModule()
        case .upcoming:
            return buildUpcomingModule()
        case .search:
            return buildSearchModule()
        case .downloads:
            return buildDownloadModule()
        case .movieDetail(let movie, let isButtonHidden):
            return buildMovieDetailModule(with: movie, isDownloadButtonHidden: isButtonHidden)
        }
    }
    
    //MARK: Private methods
    private func buildHomeModule() -> UIViewController {
        let viewModel = HomeViewModel()
        let homeVc = HomeViewController(viewModel: viewModel, builder: self)
        return UINavigationController(rootViewController: homeVc)
    }
    
    private func buildUpcomingModule() -> UIViewController {
        let viewModel = UpcomingViewModel()
        let upcomingVc = UpcomingViewController(viewModel: viewModel, builder: self)
        return UINavigationController(rootViewController: upcomingVc)
    }
    
    private func buildSearchModule() -> UIViewController {
        let viewModel = SearchViewModel()
        let searchVC = SearchViewController(viewModel: viewModel, builder: self)
        return UINavigationController(rootViewController: searchVC)
    }
    
    private func buildDownloadModule() -> UIViewController {
        let downloadsVC = DownloadsViewController(builder: self)
        NotificationCenter.default.addObserver(downloadsVC, selector: #selector(downloadsVC.editNewMoviesCount), name: NSNotification.movieWasSaved, object: nil)
        NotificationCenter.default.addObserver(downloadsVC, selector: #selector(downloadsVC.minusNewMoviesCount), name: NSNotification.movieWasDeleted, object: nil)
        return UINavigationController(rootViewController: downloadsVC)
    }
    
    private func buildMovieDetailModule(with movie: Movie, isDownloadButtonHidden: Bool = false) -> UIViewController {
        let viewModel = MovieDetailViewModel(movie: movie, isButtonHidden: isDownloadButtonHidden)
        let mvDetailVC = MovieDetailViewController(viewModel: viewModel)
        return UINavigationController(rootViewController: mvDetailVC)
    }
    
    //MARK: - Deinit
    // deinit { print("DEALLOCATION: \(Self.self)")}
}
