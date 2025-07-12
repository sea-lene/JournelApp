//
//  StickerCell.swift
//  Nikki
//
//  Created by Suhanee on 18/04/25.
//

import UIKit

class StickerCell: UICollectionViewCell {
    static let identifier = String(describing: StickerCell.self)

    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.pinToEdges(of: contentView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with url: String) {
        imageView.loadImage(from: url)
    }
}

