//
//  SearchViewController.swift
//  NetflixClone
//
//  Created by Алексей Павленко on 27.09.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    //MARK: - Subviews
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.showsVerticalScrollIndicator = true
        table.showsHorizontalScrollIndicator = false
        table.backgroundColor = .clear
        let imageV = UIImageView(image: UIImage(named: "noMovies"))
        imageV.contentMode = .scaleAspectFit
        table.backgroundView = imageV
        return table
    }()
    
    //MARK: - Variables
    public var viewModel: SearchViewModelProtocol = SearchViewModel()
    private var progressManager = ProgressManager()
    private let searchController = UISearchController()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Search"
        view.backgroundColor = .systemBackground
        setupTableView()
        setupViewModelCallBacks()
        setupSearchController()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    //MARK: - Private methods
    private func setupSearchController() {
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.placeholder = "Please enter movie's title"
        navigationController?.navigationBar.tintColor = .label
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.automaticallyShowsSearchResultsController = true
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.scopeButtonTitles = viewModel.getSeachScopeTitles()
        searchController.searchBar.delegate = self
        let textFieldInsideSearchBar = navigationItem.searchController?.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.tintColor = .label
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.register(FoundMovieTableViewCell.self, forCellReuseIdentifier: FoundMovieTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupViewModelCallBacks() {
        viewModel.moviesFound = { [weak self] in
            self?.tableView.backgroundView = nil
            self?.tableView.reloadData()
            self?.progressManager.remove()
        }
        
        viewModel.failedToFoundMovies = { [weak self] errorMessage in
            self?.progressManager.remove()
            self?.showAlert(title: "Ooops...", message: errorMessage, dismissAction: nil)
            self?.navigationItem.searchController?.searchBar.text = nil
        }
        
        viewModel.noMoviesExist = { [weak self] in
            let imageV = UIImageView(image: UIImage(named: "noMovies"))
            imageV.contentMode = .scaleAspectFit
            self?.tableView.backgroundView = imageV
            self?.tableView.reloadData()
            self?.progressManager.remove()
        }
    }
}

//MARK: - UITableViewDataSource & Delegate
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FoundMovieTableViewCell.identifier, for: indexPath) as? FoundMovieTableViewCell else { return UITableViewCell() }
        let movie = viewModel.getMovieForCell(at: indexPath.row)
        cell.setupCell(with: movie, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 5.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = viewModel.getMovieForCell(at: indexPath.row)
        self.showMovieDetailVC(with: movie)
    }
}

//MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        progressManager.show(on: self)
        let query = searchBar.text ?? ""
        let placeholder = "Please enter \(viewModel.getSeachScopeTitles()[selectedScope].lowercased())'s title"
        navigationItem.searchController?.searchBar.placeholder = placeholder
        viewModel.searchWithQuery(query, forScopeAtIndex: selectedScope)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        progressManager.show(on: self)
        let selectedScopeIndex = searchBar.selectedScopeButtonIndex
        viewModel.searchWithQuery("", forScopeAtIndex: selectedScopeIndex)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        progressManager.show(on: self)
        let query = searchBar.text ?? ""
        let selectedScopeIndex = searchBar.selectedScopeButtonIndex
        viewModel.searchWithQuery(query, forScopeAtIndex: selectedScopeIndex)
    }
}
