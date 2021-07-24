//
//  Button.swift
//  Paint
//
//  Created by Alan Podgornov on 24.07.2021.
//

import UIKit

final class Button: UIButton {
	private let imageName: String
	
	var onButtonTapAction: ((UIButton) -> ())?
	
	init(imageName: String) {
		self.imageName = imageName
		super.init(frame: .zero)
		setup()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setup() {
		translatesAutoresizingMaskIntoConstraints = false
		setImage(UIImage(named: imageName), for: .normal)
		addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)
	}
	
	@objc private func onButtonTap() {
		onButtonTapAction?(self)
	}
	
	// TODO: Пофиксить
//	override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//		let view = self
//		view.frame = CGRect(x: view.frame.origin.x - 5,
//							y: view.frame.origin.y - 5,
//							width: view.frame.width + 10,
//							height: view.frame.height + 10)
//		return view
//	}
	
}
