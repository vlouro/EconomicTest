//
//  NewReceiptViewController.swift
//  EconomicChallenge
//
//  Created by Valter Louro on 31/03/2025.
//

import UIKit
import AVFoundation

// Allows user to input new receipt info and save it
class NewReceiptViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var viewModel = ReceiptViewModel()

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
        setupUI()
    }

    // MARK: - UI Setup
    func setupUI() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameField.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        amountField.translatesAutoresizingMaskIntoConstraints = false
        currencyField.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false

        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = .secondarySystemFill
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickImage)))

        nameField.placeholder = "Receipt Name"
        nameField.borderStyle = .roundedRect

        amountField.placeholder = "Amount"
        amountField.borderStyle = .roundedRect
        amountField.keyboardType = .decimalPad

        currencyField.placeholder = "Currency (e.g., USD)"
        currencyField.borderStyle = .roundedRect

        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveReceipt), for: .touchUpInside)

        datePicker.maximumDate = Date()

        view.addSubview(imageView)
        view.addSubview(nameField)
        view.addSubview(datePicker)
        view.addSubview(amountField)
        view.addSubview(currencyField)
        view.addSubview(saveButton)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),

            nameField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            datePicker.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 20),
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            amountField.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            amountField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            amountField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            currencyField.topAnchor.constraint(equalTo: amountField.bottomAnchor, constant: 12),
            currencyField.leadingAnchor.constraint(equalTo: amountField.leadingAnchor),
            currencyField.trailingAnchor.constraint(equalTo: amountField.trailingAnchor),

            saveButton.topAnchor.constraint(equalTo: currencyField.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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
