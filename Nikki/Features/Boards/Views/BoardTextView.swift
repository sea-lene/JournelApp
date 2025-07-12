//
//  BoardTextView.swift
//  Nikki
//
//  Created by Suhanee on 18/04/25.
//

import UIKit

class BoardTextView: UITextView {

    init(text: String = "Type something...") {
        super.init(frame: .zero, textContainer: nil)
        self.text = text
        font = UIFont.systemFont(ofSize: 16)
        textColor = .black
        backgroundColor = .white
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        isEditable = true
        isScrollEnabled = false
        textAlignment = .center
        setupGestures()
    }

    private func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)

        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        addGestureRecognizer(pinchGesture)
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: superview)
        center = CGPoint(x: center.x + translation.x, y: center.y + translation.y)
        gesture.setTranslation(.zero, in: superview)
    }

    @objc private func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        transform = transform.scaledBy(x: gesture.scale, y: gesture.scale)
        gesture.scale = 1
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.superview?.bringSubviewToFront(self)
    }
}

