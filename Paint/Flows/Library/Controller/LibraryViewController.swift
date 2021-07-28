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
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(navigateToDrawingViewController))
	}
	
	// TODO: - testMethod
    #warning("наверное надо унести в координатор")
	@objc func navigateToDrawingViewController() {
		navigationController?.pushViewController(DrawingViewController(), animated: true)
	}
    
    // MARK: - test fill
    func fillData() {
        
        #warning("Сделать загрузку изображений из хранилища")
        
        let image = UIImage(named: "addDrawing")
        guard let dataImage = image?.pngData() else { return }
        drawingCollection.append(Drawing(name: "Новый рисунок", imageData: dataImage))
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.drawingCollection += StorageService.shared.restoreImages()
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
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
            #warning("Передавать выбранную картинку в канвас для рисовния")
//            drawingViewController.mainImageView.image = UIImage(data: selectedDrawing.imageData)
            navigationController?.pushViewController(drawingViewController, animated: true)
        }
	}
}
