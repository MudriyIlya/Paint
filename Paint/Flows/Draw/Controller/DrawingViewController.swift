//
//  DrawViewController.swift
//  Paint
//
//  Created by Илья Мудрый on 24.07.2021.
//

import UIKit

// MARK: - Drawing View Controller
final class DrawingViewController: DrawingCanvasViewController {
	
	// MARK: Variables
	
	private var centerCell: ToolsCollectionViewCell?
	private var currentName: String?
	
	private lazy var undoButton: ActionButton = {
		let button = ActionButton(imageName: "refresh")
		//button.backgroundColor = .blue
		return button
	}()
	
	private lazy var saveButton: ActionButton = {
		let button = ActionButton(imageName: "check")
		//button.backgroundColor = .red
		return button
	}()
	
	private lazy var exitButton: ActionButton = {
		let button = ActionButton(imageName: "exit")
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
		tableView.estimatedRowHeight = 50
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.showsVerticalScrollIndicator = false
		tableView.backgroundColor = .clear
		tableView.separatorStyle = .none
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(ColorsTableViewCell.self, forCellReuseIdentifier: "colorCell")
		tableView.register(FirstColorsTableViewCell.self, forCellReuseIdentifier: "firstColorCell")
		return tableView
	}()
	
	// MARK: Tool Picker
	private lazy var toolsCollectionView: UICollectionView = {
		let layout = ToolsCollectionViewFlowLayout()		
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.register(ToolsCollectionViewCell.self, forCellWithReuseIdentifier: "toolsCell")
		collectionView.backgroundColor = .clear
		collectionView.showsVerticalScrollIndicator = false
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.delegate = self
		collectionView.dataSource = self
		return collectionView
	}()
	
	private lazy var leftGradientView: GradientView = {
		let view = GradientView(direction: .toRight)
		return view
	}()
	
	private lazy var rightGradientView: GradientView = {
		let view = GradientView(direction: .toLeft)
		return view
	}()
	
	// TODO: сделать colors
	#warning("сделай выбор цвета")
	var colors: [UIColor] = [.black, .gray, .red, .orange, .yellow, .green, .cyan, .blue, .magenta, .purple, .brown]
	
	init(currentName: String?) {
		super.init(nibName: nil, bundle: nil)
		self.currentName = currentName
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		setupConstraints()
		setupActions()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		navigationController?.navigationBar.isHidden = true
		changeCollectionViewEdgeInsets()
	}

	override var prefersStatusBarHidden: Bool {
		return true
	}
	
	// MARK: - Setup
	
	private func setupView() {
		view.addSubview(saveButton)
		view.addSubview(undoButton)
		view.addSubview(exitButton)
		view.addSubview(colorButton)
		view.addSubview(colorsTableView)
		view.addSubview(toolsCollectionView)
		view.addSubview(leftGradientView)
		view.addSubview(rightGradientView)
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
			saveButton.widthAnchor.constraint(equalToConstant: 20),
			saveButton.heightAnchor.constraint(equalTo: saveButton.widthAnchor)
		])
		
		NSLayoutConstraint.activate([
			undoButton.trailingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant: -15),
			undoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
			undoButton.widthAnchor.constraint(equalToConstant: 20),
			undoButton.heightAnchor.constraint(equalTo: saveButton.widthAnchor)
		])
		
		NSLayoutConstraint.activate([
			exitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
			exitButton.widthAnchor.constraint(equalToConstant: 20),
			exitButton.heightAnchor.constraint(equalTo: saveButton.widthAnchor)
		])
		
		NSLayoutConstraint.activate([
			colorButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
			colorButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
			colorButton.widthAnchor.constraint(equalToConstant: 30),
			colorButton.heightAnchor.constraint(equalToConstant: 30)
		])
		
		NSLayoutConstraint.activate([
			colorsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
			colorsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
			colorsTableView.widthAnchor.constraint(equalToConstant: 30),
			colorsTableView.heightAnchor.constraint(equalToConstant: 7 * 30)
		])
		
		NSLayoutConstraint.activate([
			toolsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
			toolsCollectionView.heightAnchor.constraint(equalToConstant: 80),
			toolsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
			toolsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
		])
		
		NSLayoutConstraint.activate([
			leftGradientView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
			leftGradientView.heightAnchor.constraint(equalToConstant: 80),
			leftGradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
			leftGradientView.widthAnchor.constraint(equalToConstant: 100)
		])
		
		NSLayoutConstraint.activate([
			rightGradientView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
			rightGradientView.heightAnchor.constraint(equalToConstant: 80),
			rightGradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
			rightGradientView.widthAnchor.constraint(equalToConstant: 100)
		])
	}
	
	private func changeCollectionViewEdgeInsets() {
		let sideInset = (self.view.frame.width / 2) - 30
		self.toolsCollectionView.contentInset = UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
	}
	
    // MARK: Button Actions
    private func setupActions() {
        undoButton.onButtonTapAction = { [weak self] _ in
            self?.undoButtonTapped()
        }
        saveButton.onButtonTapAction = { [weak self] _ in
			self?.showNameAlertController()
        }
        exitButton.onButtonTapAction = { [weak self] _ in
            self?.backToLibrary()
        }
    }
	
	@objc private func openColors() {
		colorsTableView.isHidden.toggle()
		colorButton.isHidden.toggle()
	}
	
	@objc private func saveDrawing(drawingName: String) {
		guard
			let imageToSave = mainImageView.image,
			let pngRepresentation = imageToSave.pngData()
		else { return }
		let drawingToSave = Drawing(name: drawingName, imageData: pngRepresentation)
		StorageService().save(drawing: drawingToSave)
	}
	
	private func backToLibrary() {
		self.navigationController?.popViewController(animated: true)
	}
	
	private func showNameAlertController() {
		let nameAlertController = UIAlertController(title: "Введите название", message: nil, preferredStyle: .alert)
		
		nameAlertController.addTextField { [weak self] (textField: UITextField) in
			textField.placeholder = "Название"
			textField.text = self?.currentName ?? ""
		}
		
		let saveAndReturnAction = UIAlertAction(title: "Сохранить", style: .default) { [weak self] _ in
			guard var drawingName = nameAlertController.textFields?.first?.text else { return }
			if drawingName == "" { drawingName = "IMG\(StorageService().count() + 1)" }
			self?.saveDrawing(drawingName: drawingName)
			self?.backToLibrary()
		}
		
		let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
		
		nameAlertController.addAction(saveAndReturnAction)
		nameAlertController.addAction(cancelAction)
		
		self.navigationController?.present(nameAlertController, animated: true, completion: nil)
	}
}

// MARK: Extension TableView Delegate
extension DrawingViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return colors.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let color = colors[indexPath.row]
		
		guard let cell = indexPath.row == 0 ?
				tableView.dequeueReusableCell(withIdentifier: "firstColorCell") as? FirstColorsTableViewCell :
				tableView.dequeueReusableCell(withIdentifier: "colorCell") as? ColorsTableViewCell
		else { return UITableViewCell() }
		
		cell.setupCellColor(color)
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		colorButton.backgroundColor = colors[indexPath.row]
		lineColor = colors[indexPath.row]
		openColors()
		tableView.deselectRow(at: indexPath, animated: true)
	}
}

// MARK: Extension CollectionView Delegate
extension DrawingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return tools.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "toolsCell", for: indexPath) as? ToolsCollectionViewCell else { return UICollectionViewCell() }
		var imageTool = UIImage()
		#warning("переписать force unwrap'ы")
		switch tools[indexPath.row] {
		case .Pencil:
			imageTool = UIImage(named: "pencil")!
		case .Line:
			imageTool = UIImage(named: "line")!
		case .Rectangle:
			imageTool = UIImage(named: "rectangle")!
		case .Ellipse:
			imageTool = UIImage(named: "ellipse")!
		case .Triangle:
			imageTool = UIImage(named: "triangle")!
		}
		cell.setImage(image: imageTool)
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		collectionView.deselectItem(at: indexPath, animated: false)
		collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		guard scrollView == toolsCollectionView else { return }
		let centerPoint = CGPoint(x: self.toolsCollectionView.frame.size.width / 2 + scrollView.contentOffset.x,
								  y: self.toolsCollectionView.frame.size.height / 2 + scrollView.contentOffset.y)
		if let indexPath = self.toolsCollectionView.indexPathForItem(at: centerPoint) {
			centerCell = (self.toolsCollectionView.cellForItem(at: indexPath) as? ToolsCollectionViewCell )
			centerCell?.transformToLarge()
			pickedTool = tools[indexPath.row]
		}
		
		if let cell = self.centerCell {
			let offsetX = centerPoint.x - cell.center.x
			if offsetX < -15 || offsetX > 15 {
				cell.transformToIdentity()
				self.centerCell = nil
			}
		}
	}
}
