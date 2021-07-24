//
//  LibraryCollectionViewCell.swift
//  Paint
//
//  Created by Сергей Флоря on 24.07.2021.
//

import UIKit

class LibraryCollectionViewCell: UICollectionViewCell {
    
    // MARK: Variables
    
    private lazy var drawingName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textAlignment = .center
        label.backgroundColor = .white
        return label
    }()
    
    private lazy var drawing: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.frame = contentView.frame
        return imageView
    }()
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    
    func setupView() {
        contentView.addSubview(drawingName)
        contentView.addSubview(drawing)
        
        NSLayoutConstraint.activate([
            drawingName.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0),
            drawingName.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 20),
            drawingName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            drawingName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ])
    }
    
    func configureCell(drawingModel: Drawing) {
        drawingName.text = drawingModel.name
    }
}
