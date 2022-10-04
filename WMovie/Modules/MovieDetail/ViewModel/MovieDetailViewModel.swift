//
//  MovieDetailViewModel.swift
//  WMovie
//
//  Created by Алексей Павленко on 04.10.2022.
//

import Foundation

protocol MovieDetailViewModelProtocol: AnyObject {
    var gotURLRequest: ((URLRequest) -> Void)? { get set }
    var failedToGetURLRequest: ((String) -> Void)? { get set }
    func sendYoutubeAPIRequest()
    func getMovieTitle() -> String
    func getMovieRate() -> String
    func getMovieReleaseDate() -> String
    func getMovieOverview() -> String
    func getMovieMediaType() -> String?
    func toggleStorageStatusForMovie() -> String
    func isMovieAlreadySavedCheck() -> Bool
    func isButtonAvailable() -> Bool
}

final class MovieDetailViewModel: MovieDetailViewModelProtocol {
    
    //MARK: Private variables
    private let formatter: DateFormatter = {
        let frmt = DateFormatter()
        frmt.dateFormat = "dd.MM.yyyy"
        return frmt
    }()
    private var videoID: String?
    private var movie: Movie
    private var isButtonHidden: Bool
    
    //MARK: Init
    init(videoID: String? = nil, movie: Movie, isButtonHidden: Bool) {
        self.videoID = videoID
        self.movie = movie
        self.isButtonHidden = isButtonHidden
    }
    
    //MARK: Private methods
    private func sendRequestCallBack() {
        guard let videoID = videoID, let url = URL(string: APIConstants.ytVideoBaseURL + videoID) else {
            failedToGetURLRequest?("Title trailer is not available at the moment, try again later")
            return
        }
        gotURLRequest?(URLRequest(url: url))
    }
    
    //MARK: Public variables
    var gotURLRequest: ((URLRequest) -> Void)?
    var failedToGetURLRequest: ((String) -> Void)?
    
    //MARK: Public methods
    func sendYoutubeAPIRequest() {
        NetworkManager.shared.send(request: SearchYoutubeContentRequest(query: movie.title)) { [weak self] result in
            switch result {
            case .success(let results):
                print("SUCCESS: \(results.count)")
                if !results.isEmpty {
                    self?.videoID = results[0].id.videoId
                    DispatchQueue.main.async {
                        self?.sendRequestCallBack()
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.failedToGetURLRequest?("Title trailer is not available at the moment, try again later")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.failedToGetURLRequest?(error.localizedDescription)
                }
            }
        }
    }
    
    func isButtonAvailable() -> Bool {
        return isButtonHidden
    }
    
    func getMovieTitle() -> String {
        return movie.title
    }
    
    func getMovieRate() -> String {
        guard let rating = movie.rate else { return "Rating is not available yet"}
        return rating == 0.0 ? "Rating is not available yet" : "Rating: \(rating)"
    }
    
    func getMovieReleaseDate() -> String {
        let yearFormatted = formatter.string(from: movie.year)
        let releaseString = yearFormatted == "01.01.9999" ? "Release date is unknown" : "Release date: \(yearFormatted)"
        return releaseString
    }
    
    func getMovieOverview() -> String {
        let overviewText = movie.overview ?? ""
        return overviewText.isEmpty ? "Overview is not available" : "Overview: \(overviewText)"
    }
    
    func getMovieMediaType() -> String? {
        guard let mediaType = movie.mediaType else { return nil }
        return "Media type: \(mediaType)"
    }
    
    func toggleStorageStatusForMovie() -> String {
        let isAlreadySaved = isMovieAlreadySavedCheck()
        switch isAlreadySaved {
        case false:
            let isSaved = CoreDataManager.shared.saveMovie(movie)
            return isSaved ? "📦 Saved!" : "⛔️ Could not be saved. Please try again later."
        case true:
            let isDeleted = CoreDataManager.shared.deleteMovie(movie)
            return isDeleted ? "🗑 Deleted" : "⛔️ Could not be deleted. Please try again later."
        }
    }
    
    func isMovieAlreadySavedCheck() -> Bool {
        return CoreDataManager.shared.checkIfMovieIsSaved(movie)
    }
    
    //MARK: - Deinit
    deinit { print("DEALLOCATION: \(Self.self)")}
}
