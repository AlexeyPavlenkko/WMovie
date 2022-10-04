//
//  UpcomingViewController.swift
//  NetflixClone
//
//  Created by Алексей Павленко on 27.09.2022.
//

import UIKit

final class UpcomingViewController: UIViewController {
    
    //MARK: - Subviews
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.showsVerticalScrollIndicator = true
        table.showsHorizontalScrollIndicator = false
        table.backgroundColor = .clear
        return table
    }()
    
    //MARK: - Variables
    private var progressManager = ProgressManager()
    public let viewModel: UpcomingViewModelProtocol
    weak private var builder: ModuleBuilderProtocol?
    
    //MARK: - Init
    init(viewModel: UpcomingViewModelProtocol, builder: ModuleBuilderProtocol) {
        self.viewModel = viewModel
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
        setupTableView()
        setupViewModelCallBacks()
        progressManager.show(on: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if viewModel.getNumberOfRows() == 0 {
            viewModel.loadMoreMovies()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    //MARK: - Private methods
    private func setupNavBar() {
        navigationItem.title = "Upcoming Movies"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.register(UpcomingMovieTableViewCell.self, forCellReuseIdentifier: UpcomingMovieTableViewCell.identifier)
        tableView.register(UpcomingFooterView.self, forHeaderFooterViewReuseIdentifier: UpcomingFooterView.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupViewModelCallBacks() {
        viewModel.moviesLoaded = { [weak self] in
            self?.tableView.reloadData()
            self?.progressManager.remove()
        }
        
        viewModel.loadingFailed = { [weak self] errorMessage in
            self?.showAlert(title: "Ooops...", message: errorMessage, dismissAction: nil)
            self?.progressManager.remove()
            guard let footer = self?.tableView.footerView(forSection: 0) as? UpcomingFooterView else {return}
            footer.removeIndicator()
        }
    }
    
    //MARK: - Deinit
    deinit { print("DEALLOCATION: \(Self.self)")}
}

//MARK: - CollectionDataSource & Delegate
extension UpcomingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingMovieTableViewCell.identifier, for: indexPath) as? UpcomingMovieTableViewCell else { return UITableViewCell() }
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
        guard let movieDetailVC = builder?.build(module: .movieDetail(movie: movie)) else { return }
        present(movieDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: UpcomingFooterView.identifier) as? UpcomingFooterView else { return nil }
        return footer
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard let footer = view as? UpcomingFooterView else { return }
        footer.showIndicator()
        viewModel.loadMoreMovies()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(50)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let movie = viewModel.getMovieForCell(at: indexPath.row)
        let isSavedAlready = viewModel.isMovieAlreadySavedCheck(movie)
        
        let config = UIContextMenuConfiguration(actionProvider:  { _ in
            let saveAction = UIAction(title: isSavedAlready ? "Delete" : "Save") { (action) in
                let messageReturned = self.viewModel.toggleStorageStatusFor(movie)
                self.showAlertWithAutoDismiss(message: messageReturned)
            }
            return UIMenu(title: "", children: [saveAction])
        })
        return config
    }
}
