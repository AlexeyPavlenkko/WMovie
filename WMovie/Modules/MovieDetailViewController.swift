//
//  MovieDetailViewController.swift
//  WMovie
//
//  Created by Алексей Павленко on 01.10.2022.
//

import UIKit
import WebKit

class MovieDetailViewController: UIViewController {
    
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
        indicator.tintColor = .black
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    //MARK: - Variables
    private let formatter: DateFormatter = {
        let frmt = DateFormatter()
        frmt.dateFormat = "dd.MM.yyyy"
        return frmt
    }()
    private var videoID: String?
    public var movie: Movie!

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupSubviews()
        sendYoutubeAPIRequest()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupConstraints()
    }
    
    //MARK: - @objc methods
    @objc private func saveButtonDidTapped() {
        print(#function)
    }
    
    //MARK: - Private methods
    private func setupSubviews() {
        labelsStackView.addArrangedSubview(titleLabel)
        titleLabel.text = movie.title
        
        labelsStackView.addArrangedSubview(releaseDateLabel)
        let yearFormatted = formatter.string(from: movie.year)
        if yearFormatted == "01.01.9999" {
            releaseDateLabel.text = "Release date is unknown"
        } else {
            releaseDateLabel.text = "Release date: \(yearFormatted)"
        }
        
        if let mediaType = movie.mediaType {
            labelsStackView.addArrangedSubview(mediaTypeLabel)
            mediaTypeLabel.text = "Media type: \(mediaType)"
        }
        
        if let rating = movie.rate {
            labelsStackView.addArrangedSubview(rateLabel)
            rateLabel.text = rating == 0.0 ? "Rating is not available yet" : "Rating: \(rating)"
        }
        
        labelsStackView.addArrangedSubview(overviewLabel)
        let overviewText = movie.overview ?? ""
        if overviewText.isEmpty {
            overviewLabel.text = "Overview is not available"
        } else {
            overviewLabel.text = "Overview: \(overviewText)"
        }
        
        view.addSubview(webView)
        view.addSubview(labelsStackView)
        view.addSubview(saveButton)
        view.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            webView.heightAnchor.constraint(equalToConstant: 250),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: view.topAnchor, constant: 16 + 125),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50),
            
            labelsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            labelsStackView.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 16),
            labelsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            saveButton.topAnchor.constraint(equalTo: labelsStackView.bottomAnchor, constant: 16),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            saveButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func sendYoutubeAPIRequest() {
        activityIndicator.startAnimating()
        NetworkManager.shared.send(request: SearchYoutubeContentRequest(query: movie.title)) { [weak self] result in
            switch result {
            case .success(let results):
                print("SUCCESS: \(results.count)")
                if !results.isEmpty {
                    self?.videoID = results[0].id.videoId
                    DispatchQueue.main.async {
                        self?.showWebViewContent()
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.showErrorAlert()
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showErrorAlert(error.localizedDescription)
                }
            }
        }
    }
    
    private func showWebViewContent() {
        guard let videoID = videoID, let url = URL(string: APIConstants.ytVideoBaseURL + videoID) else { return }
        activityIndicator.stopAnimating()
        print("--------VIDEO URL \(url)")
        webView.load(URLRequest(url: url))
    }
    
    private func showErrorAlert(_ errorMessage: String? = nil) {
        activityIndicator.stopAnimating()
        showAlert(title: "Error :(", message: "Title trailer is not available at the moment, try again later", dismissAction: { [weak self] _ in
            self?.presentingViewController?.dismiss(animated: true)
        })
    }
    
    //MARK: - Deinit
    deinit { print("DetailVC DEALLOCATED") }
}
