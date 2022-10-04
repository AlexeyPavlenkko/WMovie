//
//  UpcomingFooterView.swift
//  WMovie
//
//  Created by Алексей Павленко on 30.09.2022.
//

import UIKit

final class UpcomingFooterView: UITableViewHeaderFooterView {
    static let identifier = "UpcomingFooterView"
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .label
        indicator.hidesWhenStopped = true 
        return indicator
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubview(activityIndicator)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        activityIndicator.color = .label
    }
    
    public func showIndicator() {
        activityIndicator.startAnimating()
    }
    
    public func removeIndicator() {
        activityIndicator.stopAnimating()
    }
}
