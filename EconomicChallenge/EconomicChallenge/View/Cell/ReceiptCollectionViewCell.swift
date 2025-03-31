//
//  ReceiptCollectionViewCell.swift
//  EconomicChallenge
//
//  Created by Valter Louro on 31/03/2025.
//

import UIKit

//Cell to display Receipt image and date

class ReceiptCollectionViewCell: UICollectionViewCell {
    static let identifier = "ReceiptCollectionViewCell"

    let imageView = UIImageView()
    let dateLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8

        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textAlignment = .center

        contentView.addSubview(imageView)
        contentView.addSubview(dateLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),

            dateLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func configure(with model: Receipt) {
        imageView.image = model.image
        dateLabel.text = DateFormatter.localizedString(from: model.date, dateStyle: .medium, timeStyle: .none)
    }
}
