//
//  DraggableView.swift
//  Nikki
//
//  Created by Suhanee on 09/04/25.
//

import UIKit

class DraggableView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGestures()
        // Example border styling (customize as needed)
        layer.borderColor = MyAppColors.tertiary.cgColor
        layer.borderWidth = 2.0
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGestures()
    }
    
    private func setupGestures() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(pinchGesture)
        addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let view = gesture.view else { return }
        view.transform = view.transform.scaledBy(x: gesture.scale, y: gesture.scale)
        gesture.scale = 1.0
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view else { return }
        let translation = gesture.translation(in: superview)
        view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        gesture.setTranslation(.zero, in: superview)
    }
}
