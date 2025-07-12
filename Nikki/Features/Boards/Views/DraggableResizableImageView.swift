//
//  DraggableResizableImageView.swift
//  Nikki
//
//  Created by Suhanee on 18/04/25.
//

import UIKit

class DraggableResizableImageView: UIImageView {

    private var panGesture: UIPanGestureRecognizer!
    private var pinchGesture: UIPinchGestureRecognizer!

    init(imageURL: URL) {
        super.init(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        contentMode = .scaleAspectFit
        isUserInteractionEnabled = true
        backgroundColor = .clear
        clipsToBounds = true

        // Load image from URL
        loadImage(from: imageURL)

        // Gestures
        setupGestures()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func loadImage(from url: URL) {
        // Simple URL session image load
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }.resume()
    }

    private func setupGestures() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))

        self.addGestureRecognizer(panGesture)
        self.addGestureRecognizer(pinchGesture)
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: superview)
        if let view = gesture.view {
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
            gesture.setTranslation(.zero, in: superview)
        }
    }

    @objc private func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let view = gesture.view else { return }
        view.transform = view.transform.scaledBy(x: gesture.scale, y: gesture.scale)
        gesture.scale = 1.0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.superview?.bringSubviewToFront(self)
    }
}

