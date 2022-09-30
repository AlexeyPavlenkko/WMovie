//
//  FoundMovieTableViewCell.swift
//  WMovie
//
//  Created by Алексей Павленко on 30.09.2022.
//

import UIKit

class FoundMovieTableViewCell: UITableViewCell {
    static let identifier = "FoundMovieTableViewCell"

    //MARK: - Subviews
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    private let posterImageView: UIImageView = {
        let imageV = UIImageView()
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageV.contentMode = .scaleAspectFill
        imageV.clipsToBounds = true
        imageV.layer.cornerRadius = 10
        imageV.setContentHuggingPriority(.required, for: .horizontal)
        return imageV
    }()
    
    private let labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .label
        lbl.textAlignment = .left
        lbl.font = .systemFont(ofSize: 16, weight: .bold)
        lbl.setContentHuggingPriority(.required, for: .vertical)
        lbl.numberOfLines = 1
        return lbl
    }()
    
    private let releaseLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .gray
        lbl.textAlignment = .left
        lbl.font = .systemFont(ofSize: 12, weight: .semibold)
        lbl.setContentHuggingPriority(.required, for: .vertical)
        lbl.numberOfLines = 1
        return lbl
    }()
    
    private let overviewLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .label
        lbl.textAlignment = .left
        lbl.font = .systemFont(ofSize: 12, weight: .semibold)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private let formatter: DateFormatter = {
        let frmt = DateFormatter()
        frmt.dateFormat = "dd.MM.yyyy"
        return frmt
    }()
    
    //MARK: - Private Variables
    private var indexPath: IndexPath?
    
    //MARK: - Lyfecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        backgroundColor = .clear
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
        labelsStackView.addArrangedSubview(titleLabel)
        labelsStackView.addArrangedSubview(releaseLabel)
        labelsStackView.addArrangedSubview(overviewLabel)
        addSubview(posterImageView)
        addSubview(labelsStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            posterImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            posterImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            posterImageView.widthAnchor.constraint(equalTo: posterImageView.heightAnchor, multiplier: 1),
            
            labelsStackView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
            labelsStackView.topAnchor.constraint(equalTo: posterImageView.topAnchor),
            labelsStackView.bottomAnchor.constraint(equalTo: posterImageView.bottomAnchor),
            labelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
    
    //MARK: - Public methods
    public func setupCell(with movie: Movie, indexPath: IndexPath) {
        self.indexPath = indexPath
        
        titleLabel.text = movie.title
        let yearFormatted = formatter.string(from: movie.year)
        releaseLabel.text = "Release date: \(yearFormatted)"
        overviewLabel.text = "Overview: \(movie.overview ?? "-")"
        
        if let image = CacheManager.shared.getImage(for: movie.posterImage) {
            print("Using cache")
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
