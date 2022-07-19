//
//  CustomProgressView.swift
//  Notes
//
//  Created by Aleksandr Bolotov on 19.07.2022.
//

import UIKit

@IBDesignable
class CustomProgressView: UIProgressView {
    @IBInspectable
    public var cornerRadius: CGFloat = 2 {
        didSet {
            layer.cornerRadius = self.cornerRadius
        }
    }

    @IBInspectable
    public var heightScale: CGFloat = 1 {
        didSet {
            transform = transform.scaledBy(x: 1, y: heightScale)
        }
    }
}
