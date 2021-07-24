//
//  DrawViewController.swift
//  Paint
//
//  Created by Илья Мудрый on 24.07.2021.
//

import UIKit

final class DrawingViewController: UIViewController {
	
    // MARK: Variables
    
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
	
    
    // MARK: Color Picker
    private lazy var colorButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = colors.first
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(openColors), for: .touchUpInside)
        return button
    }()
    
    private lazy var colorsTableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "colorCell")
        return tableView
    }()
    
    // MARK: Tool Picker
    private lazy var toolsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 60, height: 60)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "toolsCell")
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    // TODO: colors
    #warning("сделай выбор цвета")
    var colors: [UIColor] = [.red, .cyan, .yellow, .blue, .green, .black, .brown, .magenta, .systemPink, .orange, .gray, .purple]
    
    // MARK: Lifecycle
    
	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		setupConstraints()
		setupActions()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		navigationController?.navigationBar.isHidden = true
	}
	
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: Setup
    
	private func setupView() {
		view.backgroundColor = .lightGray
		view.addSubview(saveButton)
		view.addSubview(undoButton)
        view.addSubview(colorButton)
        view.addSubview(colorsTableView)
        view.addSubview(toolsCollectionView)
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			saveButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
			saveButton.widthAnchor.constraint(equalToConstant: 20),
			saveButton.heightAnchor.constraint(equalTo: saveButton.widthAnchor)
		])
		
		NSLayoutConstraint.activate([
			undoButton.trailingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant: -15),
			undoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
			undoButton.widthAnchor.constraint(equalToConstant: 20),
			undoButton.heightAnchor.constraint(equalTo: saveButton.widthAnchor)
		])
        
        NSLayoutConstraint.activate([
            colorButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            colorButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            colorButton.widthAnchor.constraint(equalToConstant: 30),
            colorButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            colorsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            colorsTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            colorsTableView.widthAnchor.constraint(equalToConstant: 30),
            colorsTableView.heightAnchor.constraint(equalToConstant: 7 * 30)
        ])
        
        NSLayoutConstraint.activate([
            toolsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            toolsCollectionView.heightAnchor.constraint(equalToConstant: 60),
            toolsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            toolsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
	}
	
	private func setupActions() {
		undoButton.onButtonTapAction = { dfs in print("undo")}
		saveButton.onButtonTapAction = { dfs in print("save")}
	}
    
    @objc private func openColors() {
        colorsTableView.isHidden.toggle()
        colorButton.isHidden.toggle()
    }
}

// MARK: Extension TableView Delegate
extension DrawingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "colorCell") as? UITableViewCell else { return UITableViewCell() }
        cell.backgroundColor = colors[indexPath.row]
        
        //TODO: white separator
        #warning("сделай белый отступ между цветами")
//        cell.layer.borderWidth = 1
//        cell.layer.borderColor = UIColor.white.cgColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        colorButton.backgroundColor = colors[indexPath.row]
        openColors()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: Extension CollectionView Delegate
extension DrawingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO: add tools
        #warning("добавить массив инструментов")
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "toolsCell", for: indexPath) as? UICollectionViewCell else { return UICollectionViewCell() }
        
        cell.backgroundColor = colors[indexPath.row]
        
        return cell
    }
}
