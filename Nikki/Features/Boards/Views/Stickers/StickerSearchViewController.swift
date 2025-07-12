//
//  StickerSearchViewController.swift
//  Nikki
//
//  Created by Suhanee on 18/04/25.
//

import UIKit
protocol StickerSelectionDelegate: AnyObject {
    func didSelectSticker(with url: URL)
}


class StickerSearchViewController: UIViewController {

    private let apiKey = "LIVDSRZULELA" // Tenor public key
    private var stickers: [String] = []

    private let searchBar = UISearchBar()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        return cv
    }()
    
    weak var delegate: StickerSelectionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchTrendingStickers()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        searchBar.placeholder = "Search Stickers"
        searchBar.delegate = self

        view.addSubview(searchBar)
        view.addSubview(collectionView)

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(StickerCell.self, forCellWithReuseIdentifier: StickerCell.identifier)
    }

    private func fetchTrendingStickers() {
        let urlString = "https://g.tenor.com/v1/trending?key=\(apiKey)&limit=25"
        fetchStickers(from: urlString)
    }

    private func fetchSearchStickers(query: String) {
        let q = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://g.tenor.com/v1/search?q=\(q)&key=\(apiKey)&limit=25"
        fetchStickers(from: urlString)
    }

    private func fetchStickers(from urlString: String) {
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self, let data = data, error == nil else { return }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let results = json["results"] as? [[String: Any]] {
                    self.stickers = results.compactMap {
                        (($0["media"] as? [[String: Any]])?.first?["tinygif"] as? [String: Any])?["url"] as? String
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            } catch {
                print("Failed to parse stickers: \(error)")
            }
        }.resume()
    }
}

// MARK: - UICollectionView

extension StickerSearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stickers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StickerCell.identifier, for: indexPath) as? StickerCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: stickers[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sticker = stickers[indexPath.item]
        if let mediaURL = URL(string: sticker) {
            delegate?.didSelectSticker(with: mediaURL)
            dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - UISearchBarDelegate

extension StickerSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        fetchSearchStickers(query: query)
        searchBar.resignFirstResponder()
    }
}

