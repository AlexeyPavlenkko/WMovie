//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by Алексей Павленко on 27.09.2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let feedCollectionView: UICollectionView = {
        let collectionView = UICollectionView()
        
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
}


