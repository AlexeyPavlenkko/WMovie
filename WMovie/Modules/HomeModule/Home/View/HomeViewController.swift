//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by Алексей Павленко on 27.09.2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - Subviews
    private let collectionView: UICollectionView = {
        let mockLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: mockLayout)
        return collectionView
    }()

    //MARK: - Variables
    public var viewModel: HomeViewModelProtocol = HomeViewModel()
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupCollectionView()
        setupNavBar()
        setupViewModelCallBacks()
        viewModel.viewDidLoaded()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }
    
    //MARK: - @objc methods
    
    
    
    //MARK: - Private Methods
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(MainHeaderCollectionViewCell.self, forCellWithReuseIdentifier: MainHeaderCollectionViewCell.identifier)
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.register(SectionHeaderReusableView.self, forSupplementaryViewOfKind: SectionHeaderReusableView.kind, withReuseIdentifier: SectionHeaderReusableView.identifier)
        collectionView.collectionViewLayout = createCollectionViewLayout()
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupNavBar() {
        var image = UIImage(named: "movie")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person.fill"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle.fill"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.barTintColor = .systemBackground
    }
    
    private func setupViewModelCallBacks() {
        viewModel.allMoviesLoaded = { [weak self] in
            self?.collectionView.reloadData()
            print("RELOAD CALLED")
        }
    }
    
}

//MARK: - CollectionDataSource & Delegate
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.getNumberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfItemsForSection(at: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainHeaderCollectionViewCell.identifier, for: indexPath) as? MainHeaderCollectionViewCell else { return UICollectionViewCell() }
            let movie = viewModel.getMovieForCell(at: indexPath)
            cell.delegate = self
            cell.setupMainHeader(with: movie)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
            let movie = viewModel.getMovieForCell(at: indexPath)
            cell.setupCell(with: movie, indexPath: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard indexPath.section != 0 else { return UICollectionReusableView() }
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: SectionHeaderReusableView.kind, withReuseIdentifier: SectionHeaderReusableView.identifier, for: indexPath) as? SectionHeaderReusableView else { return UICollectionReusableView() }
        let title = viewModel.getHeaderTitleForSection(at: indexPath.section)
        view.setupHeaderTitle(with: title)
        return view
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard indexPath.section != 0 else { return }
        let movie = viewModel.getMovieForCell(at: indexPath)
        print(movie)
    }
}

extension HomeViewController: MainHeaderDelegate {
    func playButtonDidTapped(_ cell: MainHeaderCollectionViewCell) {
        let movie = viewModel.getMovieForCell(at: IndexPath(item: 0, section: 0))
        print("PLAY \(movie.title)")
    }
    
    func downloadButtonDidTapped(_ cell: MainHeaderCollectionViewCell) {
        let movie = viewModel.getMovieForCell(at: IndexPath(item: 0, section: 0))
        print("DOWNLOAD \(movie.title)")
    }
}

