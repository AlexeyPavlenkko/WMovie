//
//  MovieDetailViewController.swift
//  WMovie
//
//  Created by Алексей Павленко on 01.10.2022.
//

import UIKit
import WebKit

final class MovieDetailViewController: UIViewController {
    
    //MARK: - Subviews
    private let labelsStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 10
        stack.axis = .vertical
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 20, weight: .bold)
        lbl.textColor = .label
        lbl.textAlignment = .left
        lbl.numberOfLines = 1
        return lbl
    }()
    
    private let releaseDateLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 16, weight: .regular)
        lbl.textColor = .darkGray
        lbl.textAlignment = .left
        lbl.numberOfLines = 1
        return lbl
    }()
    
    private let rateLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 16, weight: .regular)
        lbl.textColor = .darkGray
        lbl.textAlignment = .left
        lbl.numberOfLines = 1
        return lbl
    }()
    
    private let mediaTypeLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 16, weight: .regular)
        lbl.textColor = .darkGray
        lbl.textAlignment = .left
        lbl.numberOfLines = 1
        return lbl
    }()
    
    private let overviewLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 16, weight: .regular)
        lbl.textColor = .label
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = .label
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(saveButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.clipsToBounds = true
        webView.backgroundColor = .label
        webView.layer.cornerRadius = 10
        return webView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.tintColor = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let placeHolderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .darkGray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .prominent)
        return UIVisualEffectView(effect: blur)
    }()
    
    //MARK: - Variables
    private let viewModel: MovieDetailViewModelProtocol
    
    //MARK: - Init
    init(viewModel: MovieDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        setupSubviews()
        activityIndicator.startAnimating()
        saveButton.isHidden = viewModel.isButtonAvailable()
        updateButtonLabel()
        setupViewModelCallBacks()
        viewModel.sendYoutubeAPIRequest()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupConstraints()
    }
    
    //MARK: - @objc methods
    @objc private func saveButtonDidTapped() {
        let messaage = viewModel.toggleStorageStatusForMovie()
        self.showAlertWithAutoDismiss(message: messaage)
        updateButtonLabel()
    }
    
    //MARK: - Private methods
    private func setupSubviews() {
        labelsStackView.addArrangedSubview(titleLabel)
        titleLabel.text = viewModel.getMovieTitle()
        
        labelsStackView.addArrangedSubview(releaseDateLabel)
        releaseDateLabel.text = viewModel.getMovieReleaseDate()
        
        if let mediaType = viewModel.getMovieMediaType() {
            labelsStackView.addArrangedSubview(mediaTypeLabel)
            mediaTypeLabel.text = mediaType
        }
        
        labelsStackView.addArrangedSubview(rateLabel)
        rateLabel.text = viewModel.getMovieRate()
        
        labelsStackView.addArrangedSubview(overviewLabel)
        overviewLabel.text = viewModel.getMovieOverview()
        
        view.addSubview(blurView)
        view.addSubview(webView)
        view.addSubview(labelsStackView)
        view.addSubview(saveButton)
        view.addSubview(placeHolderImageView)
        view.addSubview(activityIndicator)
    }
    
    private func updateButtonLabel() {
        let title = viewModel.isMovieAlreadySavedCheck() ? "Delete" : "Save"
        saveButton.setTitle(title, for: .normal)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            webView.heightAnchor.constraint(equalToConstant: 250),
            
            labelsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            labelsStackView.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 16),
            labelsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            saveButton.topAnchor.constraint(equalTo: labelsStackView.bottomAnchor, constant: 16),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            saveButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        blurView.frame = view.bounds
        placeHolderImageView.frame = webView.frame
        activityIndicator.center = placeHolderImageView.center
    }
    
    private func setupViewModelCallBacks() {
        viewModel.gotURLRequest = { [weak self] urlRequest in
            self?.showWebViewContent(with: urlRequest)
        }
        
        viewModel.failedToGetURLRequest = { [weak self] errorMessage in
            self?.showAlert(title: "Error :(", message: errorMessage, dismissAction: { _ in
                self?.activityIndicator.stopAnimating()
                self?.placeHolderImageView.image = UIImage(named: "ytVideo")
            })
        }
    }
    
    private func showWebViewContent(with urlRequest: URLRequest) {
        activityIndicator.stopAnimating()
        placeHolderImageView.removeFromSuperview()
        webView.load(urlRequest)
    }
    
    //MARK: - Deinit
    deinit { print("DEALLOCATION: \(Self.self)")}
}
