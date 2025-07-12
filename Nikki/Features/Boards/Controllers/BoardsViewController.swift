//
//  BoardsViewController.swift
//  Nikki
//
//  Created by Suhanee on 09/04/25.
//

import UIKit

class BoardsViewController: UIViewController {
    
    // MARK: - UI Components
    
    // Main canvas for board elements
    private let canvasView: UIView = {
        let view = UIView()
        view.backgroundColor = MyAppColors.accentBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Editing toolbar at the bottom of the screen
    private let editingToolbar: UIView = {
        let toolbar = UIView()
        toolbar.backgroundColor = MyAppColors.primary.withAlphaComponent(0.1)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        return toolbar
    }()
    
    // Sample draw button on the toolbar
    private lazy var drawButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "pencil.tip"), for: .normal)
        button.tintColor = MyAppColors.secondary
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(drawButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Board"
        view.backgroundColor = MyAppColors.accentBackground
        setupUI()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        // Add the canvas
        view.addSubview(canvasView)
        NSLayoutConstraint.activate([
            canvasView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            canvasView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            canvasView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // Leave space for the editing toolbar (80 points high)
            canvasView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80)
        ])
        
        // Add the editing toolbar
        view.addSubview(editingToolbar)
        NSLayoutConstraint.activate([
            editingToolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            editingToolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            editingToolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            editingToolbar.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        // Add draw button to the toolbar
        editingToolbar.addSubview(drawButton)
        NSLayoutConstraint.activate([
            drawButton.centerYAnchor.constraint(equalTo: editingToolbar.centerYAnchor),
            drawButton.leadingAnchor.constraint(equalTo: editingToolbar.leadingAnchor, constant: 20),
            drawButton.widthAnchor.constraint(equalToConstant: 40),
            drawButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // (Add additional toolbar buttons similarly for text, shapes, etc.)
    }
    
    // MARK: - Actions
    
    @objc private func drawButtonTapped() {
        // Toggle drawing mode or present drawing options here
        print("Drawing mode activated")
    }
}
