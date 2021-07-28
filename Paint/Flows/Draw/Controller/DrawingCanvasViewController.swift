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
    var lineColor = UIColor.black
    var lineWidth: CGFloat = 10.0
    var pickedTool: Tool = .Pencil
    private(set) var tools: [Tool] = [.Pencil, .Line, .Rectangle, .Ellipse, .Triangle]
    private var opacity: CGFloat = 1.0
    private var lastPoint = CGPoint.zero
    private var currentPoint = CGPoint.zero
    private var swiped = false
    
    private(set) lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = self.view.frame
        return imageView
    }()
    
    private lazy var tempImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = self.view.frame
        return imageView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(mainImageView)
        self.view.addSubview(tempImageView)
    }
    
    // MARK: - Touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        swiped = false
        lastPoint = touch.location(in: view)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
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
        
        tempImageView.image = nil
    }
    
    // MARK: - Drawing
    private func draw(from startPoint: CGPoint, to endPoint: CGPoint) {
        switch pickedTool {
        case .Pencil:
            drawLineByPencil(from: startPoint, to: endPoint)
        case .Line:
            drawLine(from: startPoint, to: endPoint)
        case .Rectangle:
            drawRectangle(from: startPoint, to: endPoint)
        case .Ellipse:
            drawEllipse(from: startPoint, to: endPoint)
        case .Triangle:
            drawTriangle(from: startPoint, to: endPoint)
        }
    }
    
    // MARK: Pencil
    func drawLineByPencil(from fromPoint: CGPoint, to toPoint: CGPoint) {
        UIGraphicsBeginImageContext(view.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        tempImageView.image?.draw(in: view.bounds)
        
        context.move(to: fromPoint)
        context.addLine(to: toPoint)
        
        context.setLineCap(.round)
        context.setBlendMode(.normal)
        context.setLineWidth(lineWidth)
        context.setStrokeColor(lineColor.cgColor)
        
        context.strokePath()
        
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
    }
    
    // MARK: Line
    func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        UIGraphicsBeginImageContext(view.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        tempImageView.image?.draw(in: view.bounds)
        context.clear(UIScreen.main.bounds)
        
        context.move(to: fromPoint)
        context.addLine(to: toPoint)
        
        context.setLineCap(.round)
        context.setBlendMode(.normal)
        context.setLineWidth(lineWidth)
        context.setStrokeColor(lineColor.cgColor)
        
        context.strokePath()
        
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
    }
    
    // MARK: Ellipse
    func drawEllipse(from fromPoint: CGPoint, to toPoint: CGPoint) {
        UIGraphicsBeginImageContext(view.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        tempImageView.image?.draw(in: view.bounds)
        context.clear(UIScreen.main.bounds)
        
        // Ellipse path
        context.addEllipse(in: CGRect(x: fromPoint.x, y: fromPoint.y, width: toPoint.x - fromPoint.x, height: toPoint.y - fromPoint.y))
        
        context.setLineCap(.round)
        context.setBlendMode(.normal)
        context.setLineWidth(lineWidth)
        context.setStrokeColor(lineColor.cgColor)
        
        context.strokePath()
        
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
    }
    
    // MARK: Rectangle
    func drawRectangle(from fromPoint: CGPoint, to toPoint: CGPoint) {
        UIGraphicsBeginImageContext(view.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        tempImageView.image?.draw(in: view.bounds)
        context.clear(UIScreen.main.bounds)
        
        // Rectangle path
        context.addRect(CGRect(x: fromPoint.x, y: fromPoint.y, width: toPoint.x - fromPoint.x, height: toPoint.y - fromPoint.y))
        
        context.setLineCap(.round)
        context.setBlendMode(.normal)
        context.setLineWidth(lineWidth)
        context.setStrokeColor(lineColor.cgColor)
        
        context.strokePath()
        
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
    }
    
    // MARK: Triangle
    func drawTriangle(from fromPoint: CGPoint, to toPoint: CGPoint) {
        UIGraphicsBeginImageContext(view.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        tempImageView.image?.draw(in: view.bounds)
        context.clear(UIScreen.main.bounds)
        
        // Triangle path
        let path = UIBezierPath()
        path.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        path.addLine(to: CGPoint(x: toPoint.x, y: fromPoint.y))
        path.addLine(to: CGPoint(x: fromPoint.x + ((toPoint.x - fromPoint.x)/2), y: toPoint.y))
        path.close()

        context.addPath(path.cgPath)
        
        context.setLineCap(.round)
        context.setBlendMode(.normal)
        context.setLineWidth(lineWidth)
        context.setStrokeColor(lineColor.cgColor)
        
        context.strokePath()
        
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
    }
}
