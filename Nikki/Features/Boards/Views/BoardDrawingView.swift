//
//  BoardDrawingView.swift
//  Nikki
//
//  Created by Suhanee on 25/04/25.
//
import UIKit
import PencilKit

protocol BoardDrawingViewDelegate: AnyObject {
    func drawingDidStart()
    func drawingDidEnd()
}

class BoardDrawingView: UIView {

    weak var delegate: BoardDrawingViewDelegate?

    // MARK: - Custom Drawing
    private var lines: [[CGPoint]] = []
    private var currentLine: [CGPoint] = []
    private var strokeColor: UIColor = .black
    private var strokeWidth: CGFloat = 2.0
    private var isScaling = false
    private var isDrawing = false
    private var pinchGesture: UIPinchGestureRecognizer!
    private var panGesture: UIPanGestureRecognizer!
    private var tapGesture: UITapGestureRecognizer!

    // MARK: - PencilKit
    private let canvasView = PKCanvasView()
    private let toolPicker = PKToolPicker()
    private var isToolPickerVisible = false {
        didSet {
            updateDashedBorder()
        }
    }
    private let scrollView = UIScrollView()

    var usePencilKit: Bool = false {
        didSet {
            scrollView.isHidden = !usePencilKit
        }
    }

    // MARK: - Dashed Border
    private let dashedBorder = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isUserInteractionEnabled = true
        setupPinchGesture()
        setupPanGesture()
        setupTapGesture()
        setupScrollCanvas()
        setupDashedBorder()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Scroll + Canvas
    private func setupScrollCanvas() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)

        canvasView.translatesAutoresizingMaskIntoConstraints = false
        canvasView.backgroundColor = .clear
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 5)

        scrollView.addSubview(canvasView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),

            canvasView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            canvasView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            canvasView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            canvasView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            canvasView.widthAnchor.constraint(equalTo: widthAnchor),
            canvasView.heightAnchor.constraint(equalTo: heightAnchor)
        ])

        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            toolPicker.setVisible(true, forFirstResponder: canvasView)
            toolPicker.addObserver(self)
            canvasView.becomeFirstResponder()
        }

        scrollView.isHidden = true
    }

    private func setupPinchGesture() {
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        pinchGesture.delegate = self
        addGestureRecognizer(pinchGesture)
    }

    private func setupPanGesture() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGesture.delegate = self
        addGestureRecognizer(panGesture)
    }

    private func setupTapGesture() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.delegate = self
        addGestureRecognizer(tapGesture)
    }

    private func setupDashedBorder() {
        dashedBorder.strokeColor = UIColor.systemBlue.cgColor
        dashedBorder.lineDashPattern = [6, 3]
        dashedBorder.fillColor = nil
        dashedBorder.lineWidth = 2
        dashedBorder.isHidden = true
        layer.addSublayer(dashedBorder)
    }

    private func updateDashedBorder() {
        dashedBorder.isHidden = !(usePencilKit && isToolPickerVisible)
        dashedBorder.path = UIBezierPath(rect: bounds).cgPath
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        dashedBorder.frame = bounds
        dashedBorder.path = UIBezierPath(rect: bounds).cgPath
    }

    // MARK: - Drawing Touches (Custom)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isScaling else { return }

        if usePencilKit {
            guard isToolPickerVisible else { return }
        } else {
            guard let point = touches.first?.location(in: self) else { return }
            isDrawing = true
            currentLine = [point]
            lines.append(currentLine)
            setNeedsDisplay()
            delegate?.drawingDidStart()
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isScaling, !usePencilKit, let point = touches.first?.location(in: self) else { return }
        if var lastLine = lines.popLast() {
            lastLine.append(point)
            lines.append(lastLine)
        }
        setNeedsDisplay()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !usePencilKit else { return }
        currentLine.removeAll()
        isDrawing = false
        delegate?.drawingDidEnd()
    }

    override func draw(_ rect: CGRect) {
        guard !usePencilKit, let context = UIGraphicsGetCurrentContext() else { return }

        context.setLineCap(.round)
        context.setLineJoin(.round)
        context.setLineWidth(strokeWidth)
        context.setStrokeColor(strokeColor.cgColor)

        for line in lines {
            guard let first = line.first else { continue }
            context.beginPath()
            context.move(to: first)
            for point in line.dropFirst() {
                context.addLine(to: point)
            }
            context.strokePath()
        }
    }

    // MARK: - Gesture Handlers
    @objc private func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .began:
            isScaling = true
        case .changed:
            let scale = gesture.scale
            transform = transform.scaledBy(x: scale, y: scale)
            gesture.scale = 1.0
        case .ended, .cancelled:
            isScaling = false
        default:
            break
        }
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard !usePencilKit else { return }

        let translation = gesture.translation(in: superview)
        if let view = gesture.view {
            view.center = CGPoint(x: view.center.x + translation.x,
                                  y: view.center.y + translation.y)
            gesture.setTranslation(.zero, in: superview)
        }
    }

    @objc private func handleTap() {
        guard !usePencilKit else { return }
        superview?.bringSubviewToFront(self)
    }

    // MARK: - Utility
    func clearCustomDrawing() {
        lines.removeAll()
        setNeedsDisplay()
    }

    func clearPencilDrawing() {
        canvasView.drawing = PKDrawing()
    }

    func getPencilDrawingImage() -> UIImage? {
        return canvasView.drawing.image(from: bounds, scale: UIScreen.main.scale)
    }

    public func setDrawingMode(usePencilKit: Bool) {
        self.usePencilKit = usePencilKit
        setNeedsDisplay()
        updateDashedBorder()
    }

    // MARK: - Touch Handling
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if usePencilKit {
            return isToolPickerVisible
        } else {
            return true
        }
    }
}

// MARK: - Scroll Zoom Delegate
extension BoardDrawingView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return canvasView
    }
}

// MARK: - Gesture Delegate
extension BoardDrawingView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - PencilKit ToolPicker Observer
extension BoardDrawingView: PKToolPickerObserver {
    func toolPickerVisibilityDidChange(_ toolPicker: PKToolPicker) {
        isToolPickerVisible = toolPicker.isVisible
    }

    func toolPickerSelectedToolDidChange(_ toolPicker: PKToolPicker) {
        canvasView.tool = toolPicker.selectedTool
    }
}
