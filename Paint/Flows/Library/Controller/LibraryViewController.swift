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
        setupNavigationBar()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        loadDataFromStorage()
    }
	
    // MARK: Setup Views
    
    private func setupConstraints() {
		self.view.addSubview(collectionView)
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
			collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
			collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
			collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
		])
	}
	
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(navigateToDrawingViewController))
    }
	
    // MARK: Navigation
	@objc func navigateToDrawingViewController() {
		navigationController?.pushViewController(DrawingViewController(), animated: true)
	}
    
    // MARK: - Load Data From Storage
    
    func loadDataFromStorage() {
        
        let image = UIImage(named: "addDrawing")
        guard let dataImage = image?.pngData() else { return }
        drawingCollection = [Drawing]()
        drawingCollection.append(Drawing(name: "Новый рисунок", imageData: dataImage))
        StorageService().restoreImages().forEach { [weak self] in
            self?.drawingCollection.append($0)
        }
        title = "You have \(drawingCollection.count - 1) drawings"
        collectionView.reloadData()
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
			navigateToDrawingViewController()
        } else {
            let drawingViewController = DrawingViewController()
            let selectedDrawing = drawingCollection[indexPath.row]
            guard let imageToOpen = UIImage(data: selectedDrawing.imageData) else { return }
            drawingViewController.openImage(with: imageToOpen)
            navigationController?.pushViewController(drawingViewController, animated: true)
        }
	}
}
