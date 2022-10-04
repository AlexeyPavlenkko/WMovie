//
//  SavedMovieTableViewCell.swift
//  WMovie
//
//  Created by Алексей Павленко on 02.10.2022.
//

import UIKit

final class SavedMovieTableViewCell: UITableViewCell {
    static let idintifier = "SavedMovieTableViewCell"
    
    //MARK: Subviews
    private let lablesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
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
    
    private let rateLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .label
        lbl.textAlignment = .left
        lbl.font = .systemFont(ofSize: 12, weight: .semibold)
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
    
    private let saveDateLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .gray
        lbl.textAlignment = .left
        lbl.font = .systemFont(ofSize: 12, weight: .semibold)
        lbl.numberOfLines = 1
        return lbl
    }()
    
    //MARK: Variables
    private let formatter: DateFormatter = {
        let frmt = DateFormatter()
        frmt.dateFormat = "dd.MM.yyyy"
        return frmt
    }()
    
    //MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubviews()
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
    
    //MARK: Private methods
    private func setupSubviews() {
        lablesStackView.addArrangedSubview(titleLabel)
        lablesStackView.addArrangedSubview(releaseLabel)
        lablesStackView.addArrangedSubview(rateLabel)
        lablesStackView.addArrangedSubview(overviewLabel)

        addSubview(posterImageView)
        addSubview(lablesStackView)
        addSubview(saveDateLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            saveDateLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            saveDateLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            saveDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            saveDateLabel.heightAnchor.constraint(equalToConstant: 20),
            
            posterImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            posterImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            posterImageView.bottomAnchor.constraint(equalTo: saveDateLabel.topAnchor, constant: -10),
            posterImageView.widthAnchor.constraint(equalTo: posterImageView.heightAnchor, multiplier: 1),
            
            lablesStackView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
            lablesStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            lablesStackView.topAnchor.constraint(equalTo: posterImageView.topAnchor, constant: 0),
            lablesStackView.bottomAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 0),
        ])
    }
    
    //MARK: Public methods
    public func setupCellWith(_ movieEntity: MovieEntity) {
        titleLabel.text = movieEntity.title
        releaseLabel.text = movieEntity.yearString
        rateLabel.text = movieEntity.rateString
        overviewLabel.text = movieEntity.formattedOverviewString
        saveDateLabel.text = movieEntity.saveDateString
        
        if let imageData = movieEntity.imageData, let image = UIImage(data: imageData) {
            posterImageView.image = image
        } else {
            posterImageView.image = UIImage(named: "noPoster")
        }
    }
}
