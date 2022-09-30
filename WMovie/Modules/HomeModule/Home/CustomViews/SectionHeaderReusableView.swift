//
//  SectionHeaderReusableView.swift
//  NetflixClone
//
//  Created by Алексей Павленко on 27.09.2022.
//

import UIKit

class SectionHeaderReusableView: UICollectionReusableView {
    static let identifier = "SectionHeaderReusableView"
    static let kind = "header"
    
    //MARK: - Subviews
    private let headerTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerTitleLabel)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    //MARK: - Private methods
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            headerTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            headerTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            headerTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
    
    //MARK: - Public Methods
    public func setupHeaderTitle(with title: String) {
        headerTitleLabel.text = title

    }
    
}
