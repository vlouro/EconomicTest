//
//  ReceiptDetailViewController.swift
//  EconomicChallenge
//
//  Created by Valter Louro on 31/03/2025.
//

import UIKit

// Displays all details about a single receipt
class ReceiptDetailViewController: UIViewController {
    
    private let receipt: Receipt
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let amountLabel = UILabel()
    private let dateLabel = UILabel()
    private let currencyLabel = UILabel()
    
    init(receipt: Receipt) {
        self.receipt = receipt
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = receipt.name
        setupUI()
    }
    
    // Layout the UI to show image and receipt fields
    private func setupUI() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        currencyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(data: receipt.image)
        
        nameLabel.text = "Name: \(receipt.name)"
        amountLabel.text = "Amount: \(receipt.amount)"
        dateLabel.text = "Date: \(DateFormatter.localizedString(from: receipt.date, dateStyle: .medium, timeStyle: .none))"
        currencyLabel.text = "Currency: \(receipt.currency)"
        
        let stack = UIStackView(arrangedSubviews: [imageView, nameLabel, amountLabel, currencyLabel, dateLabel])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .center
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 250),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
    }
}
