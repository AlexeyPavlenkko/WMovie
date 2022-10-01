//
//  UIViewController+movieDetailScreen.swift
//  WMovie
//
//  Created by Алексей Павленко on 01.10.2022.
//

import UIKit

extension UIViewController {
    func showMovieDetailVC(with movie: Movie) {
        let detailVC = MovieDetailViewController()
        detailVC.movie = movie
        //detailVC.modalPresentationStyle = .overCurrentContext
        self.present(detailVC, animated: true)
    }
}
