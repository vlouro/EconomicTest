//
//  ReceiptListViewController.swift
//  EconomicChallenge
//
//  Created by Valter Louro on 28/03/2025.
//

import UIKit

class ReceiptListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let receiptListViewModel = ReceiptListViewModel()
    private var collectionView: UICollectionView!
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "No Receipts Found"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Receipts"
               title = "Receipts"
        view.backgroundColor = .systemBackground
        setupCollectionView()
        setupNavigationBar()
        setupPlaceholder()
        
        receiptListViewModel.onChange = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.placeholderLabel.isHidden = self?.receiptListViewModel.numberOfReceipts() ?? 0 > 0
            }
        }
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 16
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ReceiptCollectionViewCell.self, forCellWithReuseIdentifier: ReceiptCollectionViewCell.identifier)
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.7)
                navigationController?.navigationBar.standardAppearance = appearance
                navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addReceipt))
    }
    
    private func setupPlaceholder() {
        view.addSubview(placeholderLabel)
        NSLayoutConstraint.activate([
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func addReceipt() {
        let addVC = NewReceiptViewController()
        navigationController?.pushViewController(addVC, animated: true)
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = receiptListViewModel.numberOfReceipts()
        placeholderLabel.isHidden = count > 0
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReceiptCollectionViewCell.identifier, for: indexPath) as? ReceiptCollectionViewCell else {
            return UICollectionViewCell()
        }
        let receipt = receiptListViewModel.receipts[indexPath.row]
        cell.configure(with: receipt)
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 48) / 2
        return CGSize(width: width, height: width + 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let receipt = receiptListViewModel.receipts[indexPath.row]
        let detailVC = ReceiptDetailViewController(receipt: receipt)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
