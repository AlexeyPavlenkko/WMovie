//
//  MovieCollectionViewCell.swift
//  NetflixClone
//
//  Created by Алексей Павленко on 27.09.2022.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    static let identifier = "MovieCollectionViewCell"
    
    //MARK: - Subviews
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: - Private variables
    private var indexPath: IndexPath?
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    override func prepareForReuse() {
        posterImageView.image = nil
    }
    
    //MARK: - Private methods
    private func setupSubviews() {
        addSubview(posterImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            posterImageView.topAnchor.constraint(equalTo: topAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    //MARK: - Public methods
    public func setupCell(with movie: Movie, indexPath: IndexPath) {
        self.indexPath = indexPath
        if let image = CacheManager.shared.getImage(for: movie.posterImage) {
            posterImageView.image = image
        } else {
            NetworkManager.shared.getImageDataFrom(path: movie.posterImage) { [weak self] data in
                guard let data = data else { return }
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    CacheManager.shared.cache(image: image, for: movie.posterImage)
                    guard self?.indexPath == indexPath else { return }
                    self?.posterImageView.image = image
                }
            }
        }
    }
    
}
