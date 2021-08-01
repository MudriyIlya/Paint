//
//  ViewController.swift
//  Paint
//
//  Created by Илья Мудрый on 24.07.2021.
//

import UIKit

final class LibraryViewController: UIViewController {
    
    // MARK: Variables
    
    private var drawings = [Drawing]()
    
    private lazy var libraryCollectionView: LibraryCollectionView = {
        let collectionView = LibraryCollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(LibraryCell.self, forCellWithReuseIdentifier: LibraryCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLibrary()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        loadDataFromStorage()
    }
    
    // MARK: Setup Views
    
    private func setupLibrary() {
        self.view.addSubview(libraryCollectionView)
        
        NSLayoutConstraint.activate([
            libraryCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            libraryCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            libraryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            libraryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
        ])
    }
    
    // MARK: Navigation Bar
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(navigateToDrawingViewController))
    }
    
    @objc func navigateToDrawingViewController() {
        navigationController?.pushViewController(DrawingViewController(), animated: true)
    }
    
    // MARK: Load Data From Storage
    
    private func loadDataFromStorage() {
        drawings = [Drawing]()
        let image = UIImage(named: "addDrawing")
        guard let dataImage = image?.pngData() else { return }
        drawings.append(Drawing(name: "Новый рисунок", imageData: dataImage))
        
        StorageService().restoreImages { [weak self] drawings in
            drawings.forEach { [weak self] in
                self?.drawings.append($0)
            }
            self?.title = "Всего рисунков: \(drawings.count - 1)"
            self?.libraryCollectionView.reloadData()
        }
    }
}

// MARK: - Extension

extension LibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        drawings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LibraryCell.identifier,
                                                            for: indexPath) as? LibraryCell else { return LibraryCell() }
        let drawing = drawings[indexPath.row]
        cell.configureCell(drawingModel: drawing)
        #warning("Выглядит костыльно. Подумать как исправить")
        cell.getName() == "Новый рисунок" ? cell.setBackgroundColor(UIColor(red: 45/255, green: 155/255, blue: 240/255, alpha: 1)) : cell.setBackgroundColor(.white)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            navigateToDrawingViewController()
        } else {
            let selectedDrawing = drawings[indexPath.row]
            let drawingViewController = DrawingViewController(withDrawing: selectedDrawing)
            navigationController?.pushViewController(drawingViewController, animated: true)
        }
    }
}
