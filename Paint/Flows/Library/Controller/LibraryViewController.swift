//
//  ViewController.swift
//  Paint
//
//  Created by Илья Мудрый on 24.07.2021.
//

import UIKit

final class LibraryViewController: UIViewController {
    
    // MARK: Variables
    
    private let reuseId = "cell"
    private var drawingCollection = [Drawing]()
    
    private lazy var widthItem: CGFloat = {
        let width = UIScreen.main.bounds.size.width / 3
        return width
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: widthItem, height: widthItem)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(LibraryCollectionViewCell.self, forCellWithReuseIdentifier: reuseId)
        collectionView.backgroundColor = .yellow
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
		setupConstraints()
        setupView()
    }
	
	private func setupConstraints() {
		self.view.addSubview(collectionView)
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
			collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
			collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
			collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
		])
	}
	
    private func setupView() {
		fillData()
		setupNavigationBar()
    }
	
	private func setupNavigationBar() {
		title = "You have \(drawingCollection.count) drawings"
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(someMethod))
	}
	
	
	// TODO: - testMethod
	@objc func someMethod() {
		navigationController?.pushViewController(DrawViewController(), animated: true)
	}
    
    // MARK: - test fill
    func fillData() {
		let image = UIImage(named: "addDrawing")
		guard let dataImage = image?.pngData() else { return }
        drawingCollection.append(Drawing(name: "t", imageData: dataImage))
        drawingCollection.append(Drawing(name: "t1s", imageData: Data()))
        drawingCollection.append(Drawing(name: "t2sdfdf", imageData: Data()))
        drawingCollection.append(Drawing(name: "t3", imageData: Data()))
        drawingCollection.append(Drawing(name: "t2sdfdf", imageData: Data()))
        drawingCollection.append(Drawing(name: "t3", imageData: Data()))
        drawingCollection.append(Drawing(name: "t2sdfdf", imageData: Data()))
        drawingCollection.append(Drawing(name: "t3", imageData: Data()))
    }
}

// MARK: - Extension

extension LibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        drawingCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as? LibraryCollectionViewCell else { return UICollectionViewCell() }
        
        let drawing = drawingCollection[indexPath.row]
        cell.configureCell(drawingModel: drawing)
        
        cell.backgroundColor = .blue
        return cell
    }
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if indexPath.row == 0 {
			someMethod()
		}
	}
}
