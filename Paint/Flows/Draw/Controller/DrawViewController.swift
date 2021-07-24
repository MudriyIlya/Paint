//
//  DrawViewController.swift
//  Paint
//
//  Created by Илья Мудрый on 24.07.2021.
//

import UIKit

final class DrawViewController: UIViewController {
	
	private lazy var undoButton: Button = {
		let button = Button(imageName: "refresh")
		//button.backgroundColor = .blue
		return button
	}()
	
	private lazy var saveButton: Button = {
		let button = Button(imageName: "check")
		//button.backgroundColor = .red
		return button
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		setupConstraints()
		setupActions()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		navigationController?.navigationBar.isHidden = true
	}
	
	private func setupView() {
		view.backgroundColor = .green
		view.addSubview(saveButton)
		view.addSubview(undoButton)
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			saveButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
			saveButton.widthAnchor.constraint(equalToConstant: 20),
			saveButton.heightAnchor.constraint(equalTo: saveButton.widthAnchor),
		])
		
		NSLayoutConstraint.activate([
			undoButton.trailingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant: -15),
			undoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
			undoButton.widthAnchor.constraint(equalToConstant: 20),
			undoButton.heightAnchor.constraint(equalTo: saveButton.widthAnchor),
		])
	}
	
	private func setupActions() {
		undoButton.onButtonTapAction = { dfs in print("undo")}
		saveButton.onButtonTapAction = { dfs in print("save")}
	}
}
