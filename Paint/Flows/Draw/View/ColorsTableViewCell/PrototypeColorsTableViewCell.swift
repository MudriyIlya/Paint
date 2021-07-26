//
//  PrototypeColorsTableViewCell.swift
//  Paint
//
//  Created by Alan Podgornov on 25.07.2021.
//

import UIKit

class PrototypeColorsTableViewCell: UITableViewCell {
	lazy var colorView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	override class var requiresConstraintBasedLayout: Bool {
		return true
	}
		
	func setupCellColor(_ color: UIColor) {
		colorView.backgroundColor = color
	}
}

