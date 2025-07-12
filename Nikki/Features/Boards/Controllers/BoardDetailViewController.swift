//
//  File.swift
//  Nikki
//
//  Created by Suhanee on 18/04/25.
//

import UIKit

class BoardDetailViewController: UIViewController {
    
    private let showMarkupButton = UIButton(type: .system)
    private var isMarkupVisible = false
    
//    private var toolboxMenu: ToolboxMenuView!
    
    private var drawingView : BoardDrawingView?


    private let canvasView = BoardCanvasView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Your Board"
        setupCanvasView()
        self.setUpToolbox()
        
    }
    
    func setUpToolbox(){
        let toolbox = ToolboxView()
        toolbox.delegate = self
        toolbox.frame = CGRect(x: view.frame.width - 200, y: view.frame.height - 300, width: 220, height: 220)
        view.addSubview(toolbox)
    }

    private func setupCanvasView() {
        view.addSubview(canvasView)
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            canvasView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            canvasView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            canvasView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            canvasView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupAddImageButton() {
        let addButton = UIButton(type: .system)
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.tintColor = .white
        addButton.backgroundColor = UIColor(named: "AccentColor") ?? .systemBlue
        addButton.layer.cornerRadius = 28
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOpacity = 0.2
        addButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        addButton.layer.shadowRadius = 5

        view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            addButton.heightAnchor.constraint(equalToConstant: 56),
            addButton.widthAnchor.constraint(equalToConstant: 56),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])

        addButton.addTarget(self, action: #selector(addImageTapped), for: .touchUpInside)
    }

    @objc private func addImageTapped() {
        let drawingView = BoardDrawingView(frame: CGRect(x: 100, y: 100, width: 300, height: 500))
        self.drawingView = drawingView
        drawingView.setDrawingMode(usePencilKit: true)
        drawingView.delegate = self
        canvasView.addSubview(drawingView)
    }
}
extension BoardDetailViewController: StickerSelectionDelegate {
    func didSelectSticker(with url: URL) {
        let imageView = DraggableResizableImageView(imageURL: url)
        canvasView.addSubview(imageView)
        imageView.center = canvasView.center
    }
}

extension BoardDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentVideoPicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.mediaTypes = ["public.movie"]
        picker.videoQuality = .typeMedium // optimize for storage
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let mediaURL = info[.mediaURL] as? URL else { return }

        // You can optionally compress video here if needed.
        addVideoToCanvas(from: mediaURL)
    }

    func addVideoToCanvas(from url: URL) {
        let videoItem = BoardVideoItemView(videoURL: url)
        view.addSubview(videoItem)
    }
}

extension BoardDetailViewController: BoardDrawingViewDelegate {
    func drawingDidStart() {
        (canvasView as? UIScrollView)?.isScrollEnabled = false
    }

    func drawingDidEnd() {
        (canvasView as? UIScrollView)?.isScrollEnabled = true
    }
}

extension BoardDetailViewController{

    private func setupShowMarkupButton() {
        showMarkupButton.setTitle("✏️ Markup", for: .normal)
        showMarkupButton.tintColor = .white
        showMarkupButton.backgroundColor = .systemPink
        showMarkupButton.layer.cornerRadius = 20
        view.addSubview(showMarkupButton)
        
        showMarkupButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            showMarkupButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            showMarkupButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            showMarkupButton.widthAnchor.constraint(equalToConstant: 100),
            showMarkupButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        showMarkupButton.addTarget(self, action: #selector(toggleMarkup), for: .touchUpInside)
    }
    
    @objc func toggleMarkup() {
        drawingView?.setDrawingMode(usePencilKit: true) // or false
    }


}

extension BoardDetailViewController: ToolboxViewDelegate {
    func didSelectTool(_ type: ToolboxToolType) {
        switch type {
        case .image:
            guard let image = UIImage(systemName: "photo") else { return }
            
            let item = BoardImageItemView(image: image)
            item.frame = CGRect(x: 100, y: 100, width: 150, height: 150)
            canvasView.canvasContentView.addSubview(item)
        case .video:
            presentVideoPicker()
        case .text:
            let textView = BoardTextView()
                textView.frame = CGRect(x: 60, y: 60, width: 200, height: 100)
                canvasView.addSubview(textView)
        case .sticker:
            let stickerVC = StickerSearchViewController()
            stickerVC.modalPresentationStyle = .fullScreen
            present(stickerVC, animated: true)
        case .drawing:
            let drawingView = BoardDrawingView(frame: CGRect(x: 100, y: 100, width: 300, height: 500))
            self.drawingView = drawingView
            drawingView.setDrawingMode(usePencilKit: true)
            drawingView.delegate = self
            canvasView.addSubview(drawingView)
        }
    }
}
