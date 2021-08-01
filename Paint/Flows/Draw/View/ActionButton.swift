//
//  Button.swift
//  Paint
//
//  Created by Alan Podgornov on 24.07.2021.
//

import UIKit

final class ActionButton: UIButton {
	private let imageName: String?
	
	var onButtonTapAction: ((ActionButton) -> ())?
	
	init(imageName: String?) {
		self.imageName = imageName
		super.init(frame: .zero)
		setup()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setup() {
		translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = 15
        layer.borderWidth = 0.7
		addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)
		guard let imageName = imageName else { return }
		setImage(UIImage(named: imageName), for: .normal)
	}
	
	@objc private func onButtonTap() {
		onButtonTapAction?(self)
	}
	
	override func point(inside point: CGPoint, with _: UIEvent?) -> Bool {
		let margin: CGFloat = 5
		let area = self.bounds.insetBy(dx: -margin, dy: -margin)
		return area.contains(point)
	}
	
	func setBackgroundColor(_ color: UIColor?) {
		backgroundColor = color
	}
	
	func setAnotherHidden() {
		isHidden.toggle()
	}
}
