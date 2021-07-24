//
//  TestViewController.swift
//  Paint
//
//  Created by Сергей Флоря on 24.07.2021.
//

import UIKit

class TestViewController: UIViewController {
    private var color = UIColor.black
    private var brushWidth: CGFloat = 10.0
    private var opacity: CGFloat = 1.0
    private var lastPoint = CGPoint.zero
    private var currentPoint = CGPoint.zero
    private var swiped = false
    
    private var cgrectArray = [CGRect]()
    
    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = self.view.frame
        return imageView
    }()
    
    private lazy var tempImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = self.view.frame
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = .cyan
        
        self.view.addSubview(mainImageView)
        self.view.addSubview(tempImageView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        swiped = false
        lastPoint = touch.location(in: view)
        print("1 \(lastPoint) \(currentPoint)")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        swiped = true
        let currentPoint = touch.location(in: view)
        //drawLine(from: lastPoint, to: currentPoint)
        //drawCircle(from: lastPoint, to: currentPoint)
        drawRectangle(from: lastPoint, to: currentPoint)
        
        //lastPoint = currentPoint
        print("2 \(lastPoint) \(currentPoint)")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            // draw a single point
            //drawLine(from: lastPoint, to: lastPoint)
            //drawCircle(from: lastPoint, to: currentPoint)
            drawRectangle(from: lastPoint, to: currentPoint)
        }
        
        // Merge tempImageView into mainImageView
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        mainImageView.image?.draw(in: view.bounds, blendMode: .normal, alpha: 1.0)
        tempImageView.image?.draw(in: view.bounds, blendMode: .normal, alpha: opacity)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        tempImageView.image = nil
        
        print("3 \(lastPoint) \(currentPoint)")
    }
    
    func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        UIGraphicsBeginImageContext(view.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        tempImageView.image?.draw(in: view.bounds)
        
        context.move(to: fromPoint)
        context.addLine(to: toPoint)
        
        context.setLineCap(.round)
        context.setBlendMode(.normal)
        context.setLineWidth(brushWidth)
        context.setStrokeColor(color.cgColor)
        
        context.strokePath()
        
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
    }
    
    func drawCircle(from fromPoint: CGPoint, to toPoint: CGPoint) {
        UIGraphicsBeginImageContext(view.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        tempImageView.image?.draw(in: view.bounds)
       
        context.clear(UIScreen.main.bounds)
        
        context.addEllipse(in: CGRect(x: fromPoint.x, y: fromPoint.y, width: toPoint.x - fromPoint.x, height: toPoint.y - fromPoint.y))
        
        context.setLineCap(.round)
        context.setBlendMode(.normal)
        context.setLineWidth(brushWidth)
        context.setStrokeColor(color.cgColor)
        
        context.strokePath()
        
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
    }
    
    func drawRectangle(from fromPoint: CGPoint, to toPoint: CGPoint) {
        UIGraphicsBeginImageContext(view.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        tempImageView.image?.draw(in: view.bounds)
       
        context.clear(UIScreen.main.bounds)
        
        context.addRect(CGRect(x: fromPoint.x, y: fromPoint.y, width: toPoint.x - fromPoint.x, height: toPoint.y - fromPoint.y))
        
        context.setLineCap(.round)
        context.setBlendMode(.normal)
        context.setLineWidth(brushWidth)
        context.setStrokeColor(color.cgColor)
        
        context.strokePath()
        
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
    }
    
    func drawTriangle(from fromPoint: CGPoint, to toPoint: CGPoint) {
        UIGraphicsBeginImageContext(view.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        tempImageView.image?.draw(in: view.bounds)
       
        context.clear(UIScreen.main.bounds)
        
        //context.addPath
        //(CGRect(x: fromPoint.x, y: fromPoint.y, width: toPoint.x - fromPoint.x, height: toPoint.y - fromPoint.y))
        
        context.setLineCap(.round)
        context.setBlendMode(.normal)
        context.setLineWidth(brushWidth)
        context.setStrokeColor(color.cgColor)
        
        context.strokePath()
        
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
        
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 200))
        path.addLine(to: CGPoint(x: 100, y: 0))
        path.addLine(to: CGPoint(x: 200, y: 200))
        path.addLine(to: CGPoint(x: 0, y: 200))
    }
    
}
