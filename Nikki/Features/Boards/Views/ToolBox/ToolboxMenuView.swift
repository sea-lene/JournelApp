//
//  ToolboxMenuView.swift
//  Nikki
//
//  Created by Suhanee on 06/07/25.
//
import UIKit

enum ToolboxToolType {
    case image, video, text, sticker, drawing
}

protocol ToolboxViewDelegate: AnyObject {
    func didSelectTool(_ type: ToolboxToolType)
}

import UIKit

class ToolboxView: UIView {

    weak var delegate: ToolboxViewDelegate?

    private let centerButton = UIButton(type: .system)
    private var isOpen = false
    private var toolButtons: [ToolboxButton] = []
    private var blurView: UIVisualEffectView!

    private let tools: [(ToolboxToolType, String)] = [
        (.image, "photo"),
        (.video, "video"),
        (.text, "textformat"),
        (.sticker, "face.smiling"),
        (.drawing, "pencil")
    ]

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBlur()
        setupCenterButton()
        createToolButtons()
        addPanGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupBlur() {
        blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurView.alpha = 0
        blurView.layer.cornerRadius = 100
        blurView.clipsToBounds = true
        insertSubview(blurView, at: 0)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurView.centerXAnchor.constraint(equalTo: centerXAnchor),
            blurView.centerYAnchor.constraint(equalTo: centerYAnchor),
            blurView.widthAnchor.constraint(equalToConstant: 220),
            blurView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }

    private func setupCenterButton() {
        centerButton.setImage(UIImage(systemName: "plus"), for: .normal)
        centerButton.tintColor = .white
        centerButton.backgroundColor = .black
        centerButton.layer.cornerRadius = 32
        centerButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(centerButton)

        NSLayoutConstraint.activate([
            centerButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            centerButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            centerButton.widthAnchor.constraint(equalToConstant: 64),
            centerButton.heightAnchor.constraint(equalToConstant: 64)
        ])

        centerButton.addTarget(self, action: #selector(toggleTools), for: .touchUpInside)
    }

    private func createToolButtons() {
        toolButtons = tools.map { (type, icon) in
            let btn = ToolboxButton(image: UIImage(systemName: icon), toolType: type)
            btn.addTarget(self, action: #selector(toolButtonTapped(_:)), for: .touchUpInside)
            btn.alpha = 0
            addSubview(btn)
            return btn
        }
    }

    @objc private func toggleTools() {
        isOpen.toggle()

        UIView.animate(withDuration: 0.3) {
            self.blurView.alpha = self.isOpen ? 1 : 0
            self.centerButton.setImage(UIImage(systemName: self.isOpen ? "xmark" : "plus"), for: .normal)

            guard let superview = self.superview else { return }

            let parentBounds = superview.bounds
            let currentPosition = self.frame.origin

            let centerX = currentPosition.x + self.frame.size.width / 2
            let centerY = currentPosition.y + self.frame.size.height / 2

            var angles: [CGFloat] = []

            // Determine open direction
            if centerY < parentBounds.height / 3 {
                // Open downward
                angles = [CGFloat.pi * 5/4, CGFloat.pi * 3/2, CGFloat.pi * 7/4, 0, CGFloat.pi / 4]
            } else if centerY > parentBounds.height * 2/3 {
                // Open upward
                angles = [CGFloat.pi * 3/4, CGFloat.pi, CGFloat.pi * 5/4, CGFloat.pi * 3/2, CGFloat.pi * 7/4]
            } else if centerX < parentBounds.width / 3 {
                // Open to the right
                angles = [CGFloat.pi / 4, 0, CGFloat.pi * 7/4, CGFloat.pi * 3/2, CGFloat.pi * 5/4]
            } else if centerX > parentBounds.width * 2/3 {
                // Open to the left
                angles = [CGFloat.pi * 3/4, CGFloat.pi, CGFloat.pi * 5/4, CGFloat.pi * 3/2, CGFloat.pi * 7/4]
            } else {
                // Default arc
                angles = [CGFloat.pi * 3/4, CGFloat.pi / 2, CGFloat.pi / 4, 0, CGFloat.pi * 7/4]
            }

            for (index, button) in self.toolButtons.enumerated() {
                let radius: CGFloat = 100
                if self.isOpen {
                    let angle = angles[index % angles.count]
                    let dx = cos(angle) * radius
                    let dy = sin(angle) * radius
                    button.center = CGPoint(x: self.centerButton.center.x + dx,
                                            y: self.centerButton.center.y + dy)
                    button.alpha = 1
                } else {
                    button.center = self.centerButton.center
                    button.alpha = 0
                }
            }
        }
    }

    @objc private func toolButtonTapped(_ sender: ToolboxButton) {
        toggleTools()
        guard let type = sender.toolType else { return }
        delegate?.didSelectTool(type)
    }

    private func addPanGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handleDrag(_:)))
        self.addGestureRecognizer(pan)
    }

    @objc private func handleDrag(_ gesture: UIPanGestureRecognizer) {
        if isOpen { toggleTools() } // 🔐 Close toolbox when dragging

        let translation = gesture.translation(in: superview)
        if let view = gesture.view {
            view.center = CGPoint(x: view.center.x + translation.x,
                                  y: view.center.y + translation.y)
            gesture.setTranslation(.zero, in: superview)
        }
    }
}
