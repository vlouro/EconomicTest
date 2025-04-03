//
//  NewReceiptViewController.swift
//  EconomicChallenge
//
//  Created by Valter Louro on 31/03/2025.
//

import UIKit
import AVFoundation

// View to input new receipt info and save it
class NewReceiptViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var viewModel = ReceiptViewModel()
    
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    
    
    // UI Elements
    let imageView = UIImageView()
    let nameField = UITextField()
    let datePicker = UIDatePicker()
    let amountField = UITextField()
    let currencyField = UITextField()
    let saveButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "New Receipt"
        navigationController?.navigationBar.tintColor = .black
        setupUI()
        
        // Adjust for keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame),
                                               name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.spacing = 16
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        
        // Configure inputs
        imageView.backgroundColor = .secondarySystemFill
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickImage)))
        
        // Center it by wrapping in a container view
        let imageContainer = UIView()
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor),
            imageContainer.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        
        nameField.placeholder = "Receipt Name"
        nameField.borderStyle = .roundedRect
        
        
        let dateContainer = UIView()
        dateContainer.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.maximumDate = Date()
        dateContainer.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: dateContainer.centerXAnchor),
            datePicker.topAnchor.constraint(equalTo: dateContainer.topAnchor),
            datePicker.bottomAnchor.constraint(equalTo: dateContainer.bottomAnchor),
            dateContainer.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        amountField.placeholder = "Amount"
        amountField.keyboardType = .decimalPad
        amountField.borderStyle = .roundedRect
        
        currencyField.placeholder = "Currency (e.g. USD, Euro)"
        currencyField.borderStyle = .roundedRect
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveReceipt), for: .touchUpInside)
        
        // Add views to the stack
        [imageContainer, nameField, dateContainer, amountField, currencyField, saveButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentStack.addArrangedSubview($0)
        }
        
        // Constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
    }
    
    // MARK: - Image Picking with Permission Check
    @objc func pickImage() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            AlertHelper.showAlert(on: self, title: "Camera Unavailable", message: "This device doesn't have a camera.")
            return
        }
        
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            presentCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    granted
                    ? self.presentCamera()
                    : AlertHelper.showAlert(on: self, title: "Camera Access Denied", message: "Please enable camera access in Settings.")
                }
            }
        case .denied, .restricted:
            AlertHelper.showAlert(on: self, title: "Camera Access Denied", message: "Please enable camera access in Settings.")
        @unknown default:
            break
        }
    }
    
    @objc private func keyboardWillChangeFrame(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        
        let isShowing = frame.origin.y < UIScreen.main.bounds.height
        let bottomInset = isShowing ? frame.height - view.safeAreaInsets.bottom : 0
        
        UIView.animate(withDuration: duration) {
            self.scrollView.contentInset.bottom = bottomInset
            self.scrollView.verticalScrollIndicatorInsets.bottom = bottomInset
        }
    }
    
    //Presents the camera
    func presentCamera() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
        }
        dismiss(animated: true)
    }
    
    // MARK: - Save Receipt
    @objc func saveReceipt() {
        let resizedImage = imageView.image?.resized(to: CGSize(width: 300, height: 500))
        
        guard let image = resizedImage?.jpegData(compressionQuality: 0.7),
              let name = nameField.text, !name.trimmingCharacters(in: .whitespaces).isEmpty,
              let amountText = amountField.text, let amount = Double(amountText), amount > 0,
              let currency = currencyField.text, !currency.trimmingCharacters(in: .whitespaces).isEmpty,
              datePicker.date <= Date() else {
            AlertHelper.showAlert(on: self, title: "Invalid Input", message: "Please fill all fields correctly and avoid future dates.")
            return
        }
        
        let model = Receipt(
            id: UUID(),
            name: name,
            date: datePicker.date,
            amount: amount,
            currency: currency,
            image: image
        )
        
        viewModel.saveReceipt(model) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
