//
//  LibraryCollectionViewCell.swift
//  Paint
//
//  Created by Сергей Флоря on 24.07.2021.
//

import UIKit

final class LibraryCollectionViewCell: UICollectionViewCell {
	
	// MARK: Variables
	
	private lazy var drawingName: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.layer.cornerRadius = 1
        label.backgroundColor = UIColor(white: 1, alpha: 0.37)
        label.font = UIFont.systemFont(ofSize: 11, weight: .black)
        label.textColor = .black
        label.textAlignment = .left
		return label
	}()
	
	private lazy var drawing: UIImageView = {
		let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
		return imageView
	}()
	
	// MARK: Initialization
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: Setup
	
	private func setupConstraints() {
		contentView.addSubview(drawing)
		contentView.addSubview(drawingName)
		
		NSLayoutConstraint.activate([
            drawingName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            drawingName.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -5),
            drawingName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            drawingName.heightAnchor.constraint(equalToConstant: 20)
		])
		
		NSLayoutConstraint.activate([
			drawing.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			drawing.topAnchor.constraint(equalTo: contentView.topAnchor),
			drawing.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			drawing.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
		])
	}
	
	func configureCell(drawingModel: Drawing) {
		drawingName.text = drawingModel.name
		drawing.image = UIImage(data: drawingModel.imageData)
	}
}
