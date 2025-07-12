//
//  BoardCanvasView.swift
//  Nikki
//
//  Created by Suhanee on 18/04/25.
//

import UIKit

class BoardCanvasView: UIScrollView, UIScrollViewDelegate {

    let canvasContentView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        minimumZoomScale = 1.0
        maximumZoomScale = 3.0
        delegate = self
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false

        canvasContentView.frame = CGRect(x: 0, y: 0, width: 2000, height: 2000)
        canvasContentView.backgroundColor = UIColor.systemBackground
        addSubview(canvasContentView)
        contentSize = canvasContentView.frame.size
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return canvasContentView
    }
}

