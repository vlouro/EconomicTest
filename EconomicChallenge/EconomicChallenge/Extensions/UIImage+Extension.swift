//
//  UIImage+Extension.swift
//  EconomicChallenge
//
//  Created by Valter Louro on 01/04/2025.
//
import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
