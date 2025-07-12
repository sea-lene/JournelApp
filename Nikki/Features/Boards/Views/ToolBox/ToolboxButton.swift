//
//  ToolboxButton.swift
//  Nikki
//
//  Created by Suhanee on 06/07/25.
//

import UIKit

class ToolboxButton: UIButton {
    var toolType: ToolboxToolType?

    init(image: UIImage?, toolType: ToolboxToolType) {
        super.init(frame: .zero)
        self.toolType = toolType
        setImage(image, for: .normal)
        backgroundColor = .white.withAlphaComponent(0.9)
        tintColor = .black
        layer.cornerRadius = 30
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: 60).isActive = true
        heightAnchor.constraint(equalToConstant: 60).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
