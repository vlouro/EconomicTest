//
//  AlertHelper.swift
//  EconomicChallenge
//
//  Created by Valter Louro on 31/03/2025.
//

import UIKit

struct AlertHelper {
    static func showAlert(on viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(alert, animated: true)
    }
}
