//
//  AppGradientView.swift
//  Paint
//
//  Created by Alan Podgornov on 27.07.2021.
//

import UIKit

final class GradientView: UIView {
	private let direction: Direction
	
	private lazy var gradient: CAGradientLayer = {
		let gradient = CAGradientLayer()
		gradient.colors = [UIColor.white.cgColor, UIColor.white.withAlphaComponent(0).cgColor]
		return gradient
	}()
	
	init(direction: Direction ) {
		self.direction = direction
		super.init(frame: .zero)
		translatesAutoresizingMaskIntoConstraints = false
		isUserInteractionEnabled = false
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupGradientDirection() {
		switch direction {
		case .toRight:
			gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
			gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
		case .toLeft:
			gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
			gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
		}
	}
	
	override func layoutSubviews() {
		setupGradientDirection()
		self.gradient.removeFromSuperlayer()
		self.gradient.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
		layer.addSublayer(gradient)
	}
}
