//
//  FirstColorsTableViewCell.swift
//  Paint
//
//  Created by Alan Podgornov on 25.07.2021.
//

import UIKit

final class FirstColorsTableViewCell: PrototypeColorsTableViewCell {
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setup()
		updateConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setup() {
		contentView.addSubview(colorView)
	}
	
	override func updateConstraints() {
		 NSLayoutConstraint.activate([
			colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			colorView.widthAnchor.constraint(equalToConstant: 30),
			colorView.heightAnchor.constraint(equalToConstant: 30),
			colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			colorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0)
		])
		
		super.updateConstraints()
	}
}
