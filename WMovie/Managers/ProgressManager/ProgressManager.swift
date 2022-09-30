//
//  ProgressManager.swift
//  WMovie
//
//  Created by Алексей Павленко on 29.09.2022.
//

import UIKit

final fileprivate class ProgressView: UIView {
    private let containerView: UIView = {
        let container = UIView()
        container.backgroundColor = .label
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    public let activityIndicator: UIActivityIndicatorView = {
        let activityInd = UIActivityIndicatorView(style: .large)
        activityInd.color = .systemBackground
        activityInd.hidesWhenStopped = true
        activityInd.translatesAutoresizingMaskIntoConstraints = false
        return activityInd
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(containerView)
        containerView.addSubview(activityIndicator)
        setupShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupShadow()
        containerView.backgroundColor = .label
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 75),
            containerView.heightAnchor.constraint(equalToConstant: 75),
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    private func setupShadow() {
        containerView.layer.cornerRadius = 10
        containerView.layer.shadowColor = UIColor.label.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowRadius = 10
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.masksToBounds = false
    }
}

struct ProgressManager {
    private var progressView: ProgressView!
    
    public mutating func show(on viewController: UIViewController, isBackgroundVisible: Bool = true) {
        progressView?.removeFromSuperview()
        progressView = ProgressView(frame: viewController.view.bounds)
        progressView.backgroundColor = isBackgroundVisible ? .systemBackground : .clear
        viewController.view.addSubview(progressView)
        progressView.activityIndicator.startAnimating()
    }
    
    public func remove() {
        progressView.activityIndicator.stopAnimating()
        progressView?.removeFromSuperview()
    }
}
