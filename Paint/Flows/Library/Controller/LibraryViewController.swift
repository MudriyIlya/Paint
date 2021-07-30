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
 
    private var collectionView: UICollectionView?
   
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavigationBar()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        loadDataFromStorage()
    }
	
    // MARK: Setup Views
    
    private func setupConstraints() {
        guard let collectionView = self.collectionView else { return }
  
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
	
    private func setupCollectionView() {
        let inset: CGFloat = 1.0
        let widthOfScreen = UIScreen.main.bounds.width
        
        // Large item
        
        let largeItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(2/3),
                                                   heightDimension: .fractionalHeight(1))
        let largeItem = NSCollectionLayoutItem(layoutSize: largeItemSize)
        largeItem.contentInsets = NSDirectionalEdgeInsets(top: inset,
                                                          leading: inset,
                                                          bottom: inset,
                                                          trailing: inset)
        
        // Small item
        
        let smallItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .fractionalHeight(1))
        let smallItem = NSCollectionLayoutItem(layoutSize: smallItemSize)
        smallItem.contentInsets = NSDirectionalEdgeInsets(top: inset,
                                                          leading: inset,
                                                          bottom: inset,
                                                          trailing: inset)
        
        // Top line
        let topNestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                        heightDimension: .absolute(widthOfScreen * 1/3))
        let topNestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: topNestedGroupSize,
                                                                subitem: smallItem,
                                                                count: 3)
        
        // Side nested group
        
        let sideNestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                                          heightDimension: .fractionalHeight(1))
        let sideNestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: sideNestedGroupSize,
                                                               subitem: smallItem,
                                                               count: 2)

        // Nested groups
        
        let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                     heightDimension: .absolute(widthOfScreen * 2/3))
        let leftNestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: nestedGroupSize,
                                                                  subitems: [largeItem, sideNestedGroup])
        let rightNestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: nestedGroupSize,
                                                                   subitems: [sideNestedGroup, largeItem])
        
        // Common group
        let commonGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                     heightDimension: .absolute(widthOfScreen * 2))
        let commonGroup = NSCollectionLayoutGroup.vertical(layoutSize: commonGroupSize,
                                                           subitems: [topNestedGroup, leftNestedGroup, topNestedGroup, rightNestedGroup])
        
        // Section
        
        let section = NSCollectionLayoutSection(group: commonGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: inset,
                                                        leading: inset,
                                                        bottom: inset,
                                                        trailing: inset)
        
        let collectionCompositionalLayout = UICollectionViewCompositionalLayout(section: section)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionCompositionalLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(LibraryCollectionViewCell.self, forCellWithReuseIdentifier: reuseId)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.collectionView = collectionView
    }
    
    // MARK: Navigation
    
	@objc func navigateToDrawingViewController() {
		navigationController?.pushViewController(DrawingViewController(currentName: nil), animated: true)
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
        collectionView?.reloadData()
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
        if indexPath.row == 0 {
            cell.backgroundColor = UIColor(red: 45/255, green: 155/255, blue: 240/255, alpha: 1)
        }
        
        return cell
    }
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if indexPath.row == 0 {
			navigateToDrawingViewController()
        } else {
			let selectedDrawing = drawingCollection[indexPath.row]
			let drawingViewController = DrawingViewController(currentName: selectedDrawing.name)
            guard let imageToOpen = UIImage(data: selectedDrawing.imageData) else { return }
            drawingViewController.openImage(with: imageToOpen)
            navigationController?.pushViewController(drawingViewController, animated: true)
        }
	}
}
