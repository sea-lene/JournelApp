//
//  BoardVideoItemView.swift
//  Nikki
//
//  Created by Suhanee on 22/04/25.
//

import UIKit
import AVFoundation
import AVKit

class BoardVideoItemView: UIView {

    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    private var panGesture: UIPanGestureRecognizer!
    private var pinchGesture: UIPinchGestureRecognizer!

    init(videoURL: URL) {
        super.init(frame: CGRect(x: 50, y: 100, width: 200, height: 150))
        setupPlayer(with: videoURL)
        setupGestures()
        styleView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupPlayer(with url: URL) {
        self.player = AVPlayer(url: url)
        self.playerLayer = AVPlayerLayer(player: player)
        if let playerLayer = self.playerLayer {
            playerLayer.videoGravity = .resizeAspect
            playerLayer.frame = bounds
            layer.addSublayer(playerLayer)
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(loopVideo),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem
        )

        player?.play()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }

    private func styleView() {
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.systemBlue.cgColor
        self.layer.borderWidth = 1
    }

    @objc private func loopVideo() {
        player?.seek(to: .zero)
        player?.play()
    }

    private func setupGestures() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))

        addGestureRecognizer(panGesture)
        addGestureRecognizer(pinchGesture)
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

