//
//  UIView+Shadow.swift
//  Nikki
//
//  Created by Suhanee on 14/04/25.
//

import UIKit

extension UIView {
    func applyShadow(color: UIColor = .black, alpha: Float = 0.2, x: CGFloat = 0, y: CGFloat = 4, blur: CGFloat = 10) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = alpha
        layer.shadowOffset = CGSize(width: x, height: y)
        layer.shadowRadius = blur / 2.0
        layer.masksToBounds = false
    }
    
    func pinToEdges(of superview: UIView, padding: CGFloat = 0) {
            NSLayoutConstraint.activate([
                self.topAnchor.constraint(equalTo: superview.topAnchor, constant: padding),
                self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -padding),
                self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: padding),
                self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -padding)
            ])
        }
}
