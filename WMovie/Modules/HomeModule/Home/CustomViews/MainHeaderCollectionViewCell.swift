//
//  MainHeaderCollectionViewCell.swift
//  NetflixClone
//
//  Created by Алексей Павленко on 27.09.2022.
//

import UIKit

protocol MainHeaderDelegate: AnyObject {
    func playButtonDidTapped(_ cell: MainHeaderCollectionViewCell)
    func downloadButtonDidTapped(_ cell: MainHeaderCollectionViewCell)
}

class MainHeaderCollectionViewCell: UICollectionViewCell {
    static let identifier = "MainHeaderCollectionViewCell"
    
    //MARK: - Subviews
    private let posterImageView: UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFill
        imageV.clipsToBounds = true
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.circle"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 30, weight: .regular), forImageIn: .normal)
        button.tintColor = .label
        button.backgroundColor = .clear
        return button
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.up.circle"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 30, weight: .regular), forImageIn: .normal)
        button.tintColor = .label
        button.backgroundColor = .clear
        return button
    }()
    
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.systemBackground.cgColor]
        return gradientLayer
    }()
    
    //MARK: - Variables
    weak var delegate: MainHeaderDelegate?
    
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = false
        addSubviews()
        setupTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupConstraints()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.systemBackground.cgColor]
        playButton.layer.borderColor = UIColor.label.cgColor
        downloadButton.layer.borderColor = UIColor.label.cgColor
    }
    
    //MARK: - @objc methods
    
    @objc private func playButtonDidTapped() {
        delegate?.playButtonDidTapped(self)
    }
    
    @objc private func downloadButtonDidTapped() {
        delegate?.downloadButtonDidTapped(self)
    }
    
    
    //MARK: - Private methods
    private func addSubviews() {
        addSubview(posterImageView)
        layer.addSublayer(gradientLayer)
        buttonsStackView.addArrangedSubview(playButton)
        buttonsStackView.addArrangedSubview(downloadButton)
        addSubview(buttonsStackView)
    }
    
    private func setupConstraints() {
        posterImageView.frame = bounds
        gradientLayer.frame = bounds
        
        NSLayoutConstraint.activate([
            playButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1),
            downloadButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 50),
            buttonsStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    private func setupTargets() {
        playButton.addTarget(self, action: #selector(playButtonDidTapped), for: .touchUpInside)
        downloadButton.addTarget(self, action: #selector(downloadButtonDidTapped), for: .touchUpInside)
    }
    
    //MARK: - Public methods
    
    public func setupMainHeader(with movie: Movie) {
        if let image = CacheManager.shared.getImage(for: movie.posterImage) {
            posterImageView.image = image
        } else {
            NetworkManager.shared.getImageDataFrom(path: movie.posterImage) { [weak self] data in
                guard let data = data else { return }
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self?.posterImageView.image = image
                    CacheManager.shared.cache(image: image, for: movie.posterImage)
                }
            }
        }
    }
    
}
