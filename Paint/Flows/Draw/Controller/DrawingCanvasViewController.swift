//
//  DrawingCanvasViewController.swift
//  Paint
//
//  Created by Сергей Флоря on 24.07.2021.
//

import UIKit
// MARK: - View Controller
class DrawingCanvasViewController: UIViewController {
    
    // MARK: Variables
    
    private(set) var tools: [Tool] = [.Pencil, .Line, .Rectangle, .Ellipse, .Triangle]
    private(set) var pickedTool: Tool = .Pencil
    private(set) var lineColor = UIColor.black
    private(set) var lineWidth: CGFloat = 10.0
    private(set) var opacity: CGFloat = 1.0
    
    private var lastPoint: CGPoint?
    private var currentPoint: CGPoint?
    private var swiped = false
    
    private var openedImage: UIImage?
    private var historyImages = [UIImage]()
    
    private(set) lazy var mainImageView: UIImageView = {
        return makeCanvas()
    }()
    
    private lazy var tempImageView: UIImageView = {
        return makeCanvas()
    }()
    
    private func makeCanvas() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.frame = Screen.bounds
        return imageView
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        if let image = openedImage {
            mainImageView.image = image
        }
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(mainImageView)
        self.view.addSubview(tempImageView)
    }
    
    func undoButtonTapped() {
        let openedImageCount = openedImage == nil ? 0 : 1
        if historyImages.count > openedImageCount {
            historyImages.removeLast()
            mainImageView.image = historyImages.last
        }
    }
    
    // MARK: - Configure tools
    
    func setPickedTool(_ tool: Tool) {
        self.pickedTool = tool
    }
    
    func setLineColor(_ color: UIColor) {
        self.lineColor = color
    }
    
    func setLineWidth(_ width: CGFloat) {
        self.lineWidth = width
    }
    
    func setOpacity(_ opacity: CGFloat) {
        self.opacity = opacity
    }
    
    func openImage(with image: UIImage) {
        self.openedImage = image
        historyImages.append(image)
    }
    
    private func configureContextForDrawing(_ context: CGContext) {
        context.setLineCap(.round)
        context.setBlendMode(.normal)
        context.setLineWidth(lineWidth)
        context.setStrokeColor(lineColor.cgColor)
    }
    
    // MARK: - Touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        swiped = false
        lastPoint = touch.location(in: view)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        swiped = true
        let currentPoint = touch.location(in: view)
        
        draw(from: lastPoint, to: currentPoint)
        if pickedTool == .Pencil {
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            draw(from: lastPoint, to: currentPoint)
        }
        
        // Merge tempImageView into mainImageView
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        mainImageView.image?.draw(in: view.bounds, blendMode: .normal, alpha: 1.0)
        tempImageView.image?.draw(in: view.bounds, blendMode: .normal, alpha: opacity)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let imageToHistory = mainImageView.image else { return }
        historyImages.append(imageToHistory)
        tempImageView.image = nil
    }
    
    // MARK: - Drawing
    private func draw(from startPoint: CGPoint?, to endPoint: CGPoint?) {
        guard let startPoint = startPoint else { return }
        let end: CGPoint = endPoint ?? startPoint
        
        UIGraphicsBeginImageContext(view.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        configureContextForDrawing(context)
        tempImageView.image?.draw(in: view.bounds)
        
        if pickedTool != Tool.Pencil {
            guard startPoint != end else { return }
            context.clear(UIScreen.main.bounds)
        }
        
        switch pickedTool {
        case .Pencil, .Line:
            context.move(to: startPoint)
            context.addLine(to: end)
        case .Ellipse:
            context.addEllipse(in: CGRect(x: startPoint.x, y: startPoint.y, width: end.x - startPoint.x, height: end.y - startPoint.y))
        case .Rectangle:
            context.addRect(CGRect(x: startPoint.x, y: startPoint.y, width: end.x - startPoint.x, height: end.y - startPoint.y))
        case .Triangle:
            context.addPath(triangleCGPath(startPoint: startPoint, endPoint: end))
        }
        
        context.strokePath()
        
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
    }
    
    private func triangleCGPath(startPoint: CGPoint, endPoint: CGPoint) -> CGPath {
        // Triangle path
        let path = UIBezierPath()
        path.move(to: CGPoint(x: startPoint.x, y: startPoint.y))
        path.addLine(to: CGPoint(x: endPoint.x, y: startPoint.y))
        path.addLine(to: CGPoint(x: startPoint.x + ((endPoint.x - startPoint.x)/2), y: endPoint.y))
        path.close()
        return path.cgPath
    }
}
