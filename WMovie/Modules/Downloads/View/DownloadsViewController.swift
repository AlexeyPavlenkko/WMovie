//
//  DownloadsViewController.swift
//  NetflixClone
//
//  Created by Алексей Павленко on 27.09.2022.
//

import UIKit
import CoreData

final class DownloadsViewController: UIViewController {
    
    //MARK: - Subviews
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = true
        tableView.backgroundColor = .clear
        return tableView
    }()

    //MARK: - Variables
    private var fetchedResultsController: NSFetchedResultsController<MovieEntity>!
    private var searchController = UISearchController()
    private var newMoviesCount: Int = 0 {
        didSet {
            updateTabBarItem()
        }
    }
    private var sortedBy: CoreDataSortDescriptor = .latestSaved
    weak private var builder: ModuleBuilderProtocol?
    
    //MARK: - Init
    init(builder: ModuleBuilderProtocol) {
        self.builder = builder
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupNavBar()
        prepareFetchedResultsController()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        newMoviesCount = 0
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    //MARK: - @objc
    @objc func editNewMoviesCount() {
        newMoviesCount += 1
    }
    
    @objc func minusNewMoviesCount() {
        if newMoviesCount > 0 {
            newMoviesCount -= 1
        }
    }
    
    //MARK: - Private methods
    private func setupNavBar() {
        navigationItem.title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.grid.1x2.fill"), menu: createMenuForTabBarItem())
        navigationController?.navigationBar.tintColor = .label
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.placeholder = "Please enter movie's title"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private func createMenuForTabBarItem() -> UIMenu {
        let latestSavedAction = UIAction(title: "Sort by save date", image: UIImage(systemName: "clock.fill"), state: sortedBy == .latestSaved ? .on : .off) { [weak self] _ in
            self?.sortedBy = .latestSaved
            self?.navigationItem.rightBarButtonItem?.menu = self?.createMenuForTabBarItem()
            self?.navigationItem.searchController?.searchBar.text = nil
            self?.prepareFetchedResultsController(sortedBy: .latestSaved, query: nil)
        }
        
        let latestReleasedAction = UIAction(title: "Sort by release date", image: UIImage(systemName: "clock.fill"), state: sortedBy == .latestReleased ? .on : .off) { [weak self] _ in
            self?.sortedBy = .latestReleased
            self?.navigationItem.rightBarButtonItem?.menu = self?.createMenuForTabBarItem()
            self?.navigationItem.searchController?.searchBar.text = nil
            self?.prepareFetchedResultsController(sortedBy: .latestReleased, query: nil)
        }
        
        let alpabeticalAction = UIAction(title: "Sort by title", image: UIImage(systemName: "clock.fill"), state: sortedBy == .alpabetical ? .on : .off) { [weak self] _ in
            self?.sortedBy = .alpabetical
            self?.navigationItem.rightBarButtonItem?.menu = self?.createMenuForTabBarItem()
            self?.navigationItem.searchController?.searchBar.text = nil
            self?.prepareFetchedResultsController(sortedBy: .alpabetical, query: nil)
        }
        
        let topRatedAction = UIAction(title: "Sort by rating", image: UIImage(systemName: "clock.fill"), state: sortedBy == .topRating ? .on : .off) { [weak self] _ in
            self?.sortedBy = .topRating
            self?.navigationItem.rightBarButtonItem?.menu = self?.createMenuForTabBarItem()
            self?.navigationItem.searchController?.searchBar.text = nil
            self?.prepareFetchedResultsController(sortedBy: .topRating, query: nil)
        }
        
        return UIMenu(children: [latestSavedAction, latestReleasedAction, alpabeticalAction, topRatedAction])
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.register(SavedMovieTableViewCell.self, forCellReuseIdentifier: SavedMovieTableViewCell.idintifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func updateTabBarItem() {
        tabBarItem.badgeColor = .red
        if newMoviesCount == 0 {
            tabBarController?.viewControllers?[3].tabBarItem.badgeValue = nil
        } else {
            tabBarController?.viewControllers?[3].tabBarItem.badgeValue = "\(newMoviesCount)"
        }
    }
    
    //MARK: - Deinit
    deinit { print("DEALLOCATION: \(Self.self)")}
}

//MARK: - UITableViewDataSource & Delegate
extension DownloadsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        let imageV = UIImageView(image: UIImage(named: "noMovies"))
        imageV.contentMode = .scaleAspectFit
        tableView.backgroundView = sections[0].numberOfObjects == 0 ?  imageV : nil
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SavedMovieTableViewCell.idintifier, for: indexPath) as? SavedMovieTableViewCell else { return UITableViewCell() }
        cell.setupCellWith(movieEntity(for: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        deleteMovie(at: indexPath)
        let imageV = UIImageView(image: UIImage(named: "noMovies"))
        imageV.contentMode = .scaleAspectFit
        tableView.backgroundView = sections[0].numberOfObjects == 0 ?  imageV : nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movieEntity = movieEntity(for: indexPath)
        let movie = Movie(movieEntity)
        guard let movieDetailVC = builder?.build(module: .movieDetail(movie: movie, isButtonHidden: true)) else {
            showAlert(title: "Ooops...", message: "Something went wrong! Please try again later.")
            return }
        present(movieDetailVC, animated: true)
    }
}

//MARK: - SearchBarDelegate
extension DownloadsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            prepareFetchedResultsController(sortedBy: sortedBy)
        } else {
            prepareFetchedResultsController(sortedBy: sortedBy, query: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        prepareFetchedResultsController(sortedBy: sortedBy)
    }
}

//MARK: - Core Data
extension DownloadsViewController {
    private func prepareFetchedResultsController(sortedBy: CoreDataSortDescriptor = .latestSaved, query: String? = nil) {
        fetchedResultsController = CoreDataManager.shared.fetchedResultsController(sortedBy: sortedBy, query: query)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
            self.tableView.reloadData()
        } catch let error {
            fatalError("Failed to init fetchedResultsController. \(error.localizedDescription)")
        }
    }
}

//MARK: - NSFetchedResultsController Helpers
extension DownloadsViewController {
    private var sections: [NSFetchedResultsSectionInfo] {
        return fetchedResultsController.sections ?? []
    }
    
    private func movieEntity(for indexPath: IndexPath) -> MovieEntity {
        fetchedResultsController.object(at: indexPath)
    }
    
    private func deleteMovie(at indexPath: IndexPath) {
        let _ = CoreDataManager.shared.deleteMovie(movieEntity(for: indexPath))
    }
}

//MARK: - NSFetchedResultsControllerDelegate
extension DownloadsViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .move, .update:
            break
        @unknown default: self.showAlertWithAutoDismiss(message: ("Unknown type \(type) detected."))
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
        @unknown default: fatalError("Unknown type \(type) detected.")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
