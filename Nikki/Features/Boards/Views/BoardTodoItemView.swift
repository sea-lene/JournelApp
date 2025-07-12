//
//  BoardTodoItemView.swift
//  Nikki
//
//  Created by Suhanee on 18/04/25.
//

import UIKit

class BoardTodoItemView: UIView {

    private let titleLabel = UILabel()
    private let stackView = UIStackView()
    private let containerView = UIView()

    private var panGesture: UIPanGestureRecognizer!
    private var pinchGesture: UIPinchGestureRecognizer!

    private var items = ["First task", "Second task", "Another one"]

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupGestures()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        self.backgroundColor = UIColor.systemBackground
        self.layer.cornerRadius = 12
        self.layer.borderColor = UIColor.label.cgColor
        self.layer.borderWidth = 1
        self.clipsToBounds = true

        // Title
        titleLabel.text = "To-Do List"
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.setContentHuggingPriority(.required, for: .vertical)

        // StackView for checkboxes
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.isLayoutMarginsRelativeArrangement = false
        stackView.alignment = .leading // tighter left alignment
        stackView.translatesAutoresizingMaskIntoConstraints = false

        for item in items {
            let checkbox = makeCheckBoxItem(title: item)
            stackView.addArrangedSubview(checkbox)
        }

        // Container
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(stackView)

        containerView.pinToEdges(of: self, padding: 10)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 20), // CONTROL HEIGHT

            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
//            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -4)
        ])
    }

    private func makeCheckBoxItem(title: String) -> UIView {
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.spacing = 6
        hStack.alignment = .center
        hStack.distribution = .fill
        hStack.translatesAutoresizingMaskIntoConstraints = false

        let checkbox = UIButton(type: .system)
        checkbox.setImage(UIImage(systemName: "square"), for: .normal)
        checkbox.tintColor = .systemGreen
        checkbox.contentHorizontalAlignment = .fill
        checkbox.contentVerticalAlignment = .fill
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.widthAnchor.constraint(equalToConstant: 20).isActive = true
        checkbox.heightAnchor.constraint(equalToConstant: 20).isActive = true
        checkbox.addTarget(self, action: #selector(toggleCheckbox(_:)), for: .touchUpInside)

        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)

        hStack.addArrangedSubview(checkbox)
        hStack.addArrangedSubview(label)

        return hStack
    }


    @objc private func toggleCheckbox(_ sender: UIButton) {
        let isChecked = sender.currentImage == UIImage(systemName: "checkmark.square")
        let newImage = isChecked ? UIImage(systemName: "square") : UIImage(systemName: "checkmark.square")
        sender.setImage(newImage, for: .normal)
    }

    private func setupGestures() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))

        self.addGestureRecognizer(panGesture)
        self.addGestureRecognizer(pinchGesture)
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        if let view = gesture.view {
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
            gesture.setTranslation(.zero, in: self.superview)
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
