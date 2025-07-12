//
//  BoardListViewController.swift
//  Nikki
//
//  Created by Suhanee on 14/04/25.
//

import UIKit

class BoardListViewController: UIViewController {

    private let viewModel = BoardListViewModel()
    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppTheme.backgroundColor
        title = "Your Boards"
        setupCollectionView()
        setupFloatingButton()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width * 0.4, height: 160)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 80, right: 20)
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(BoardCell.self, forCellWithReuseIdentifier: BoardCell.reuseIdentifier)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupFloatingButton() {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = AppTheme.primaryColor
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 28
        button.applyShadow()
        
        button.addTarget(self, action: #selector(addBoardTapped), for: .touchUpInside)

        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 56),
            button.widthAnchor.constraint(equalToConstant: 56),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
    }
    
    @objc private func addBoardTapped() {
        let alert = UIAlertController(title: "New Board", message: "Enter a board title", preferredStyle: .alert)
        alert.addTextField()
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
            if let title = alert.textFields?.first?.text, !title.isEmpty {
                BoardManager.shared.addBoard(title: title)
                self.viewModel.addBoard(title: title)
                self.collectionView.reloadData()
            }
        }))
        
        present(alert, animated: true)
    }
}

extension BoardListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.boards.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoardCell.reuseIdentifier, for: indexPath) as? BoardCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: viewModel.boards[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let board = viewModel.getBoard(at: indexPath.item)
        let detailVC = BoardDetailViewController()
        navigationController?.pushViewController(detailVC, animated: true)
    }

}

