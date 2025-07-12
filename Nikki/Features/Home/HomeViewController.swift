//
//  HomeViewController.swift
//  Nikki
//
//  Created by Suhanee on 07/04/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let titleLabel : UILabel = {
        let  label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.text = "My journal"
        label.textColor = MyAppColors.textColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addBoardButton : UIButton = {
        let button = UIButton()
        // Set system "plus" icon with original rendering (so our white tint appears)
        let plusImage = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
        button.setImage(plusImage, for: .normal)
        
        button.backgroundColor = MyAppColors.primary
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = MyAppColors.accentBackground
        setupUI()
        addBoardButton.addTarget(self, action: #selector(addBoardTapped), for: .touchUpInside)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(addBoardButton)
        
        NSLayoutConstraint.activate([
            // Title label centered at the top
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Floating button at bottom-right
            addBoardButton.widthAnchor.constraint(equalToConstant: 60),
            addBoardButton.heightAnchor.constraint(equalToConstant: 60),
            addBoardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            addBoardButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func addBoardTapped() {
        let boardsVC = BoardsViewController()
        navigationController?.pushViewController(boardsVC, animated: true)
    }


}
