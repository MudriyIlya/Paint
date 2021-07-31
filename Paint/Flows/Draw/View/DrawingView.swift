//
//  DrwaingView.swift
//  Paint
//
//  Created by Alan Podgornov on 31.07.2021.
//

import UIKit

final class DrawingView: UIView {
	
	private(set) lazy var undoButton: ActionButton = {
		let button = ActionButton(imageName: "refresh")
		return button
	}()
	
	private(set) lazy var saveButton: ActionButton = {
		let button = ActionButton(imageName: "check")
		return button
	}()
	
	private(set) lazy var exitButton: ActionButton = {
		let button = ActionButton(imageName: "exit")
		return button
	}()
	
	private(set) lazy var colorButton: ActionButton = {
		let button = ActionButton(imageName: nil)
		return button
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		translatesAutoresizingMaskIntoConstraints = false
		addSubviews()
		setupConstraints()
		//backgroundColor = .red
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func addSubviews() {
		addSubview(undoButton)
		addSubview(saveButton)
		addSubview(exitButton)
		addSubview(colorButton)
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
			saveButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
			saveButton.widthAnchor.constraint(equalToConstant: 20),
			saveButton.heightAnchor.constraint(equalTo: saveButton.widthAnchor)
		])
		
		NSLayoutConstraint.activate([
			undoButton.trailingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant: -15),
			undoButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
			undoButton.widthAnchor.constraint(equalToConstant: 20),
			undoButton.heightAnchor.constraint(equalTo: saveButton.widthAnchor)
		])
		
		NSLayoutConstraint.activate([
			exitButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
			exitButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
			exitButton.widthAnchor.constraint(equalToConstant: 20),
			exitButton.heightAnchor.constraint(equalTo: saveButton.widthAnchor)
		])
		
		NSLayoutConstraint.activate([
			colorButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
			colorButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 60),
			colorButton.widthAnchor.constraint(equalToConstant: 30),
			colorButton.heightAnchor.constraint(equalToConstant: 30)
		])
	}
}
