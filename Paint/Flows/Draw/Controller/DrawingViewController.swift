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
    
    private lazy var exitButton: Button = {
        let button = Button(imageName: "exit")
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
	
	private let firstIndexPath = IndexPath(row: 0, section: 0)
	
    // TODO: сделать colors
	#warning("сделай выбор цвета")
    var colors: [UIColor] = [.black, .red, .cyan, .yellow, .blue, .green, .black, .brown, .magenta, .systemPink, .orange, .gray, .purple, .brown]
    
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		setupConstraints()
		setupActions()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
	}
	
	override func viewDidAppear(_ animated: Bool) {
		changeCollectionViewEdgeInsets()
		leftGradientView.setupGradientLayer()
		rightGradientView.setupGradientLayer()
		toolsCollectionView.selectItem(at: firstIndexPath, animated: true, scrollPosition: .centeredHorizontally)
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
            exitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            exitButton.widthAnchor.constraint(equalToConstant: 20),
            exitButton.heightAnchor.constraint(equalTo: saveButton.widthAnchor)
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
		let layoutMargins: CGFloat = self.toolsCollectionView.layoutMargins.left +
			self.toolsCollectionView.layoutMargins.right
		let sideInset = (self.view.frame.width / 2) - layoutMargins
		self.toolsCollectionView.contentInset = UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
	}
	
    // MARK: Button Actions
    private func setupActions() {
        undoButton.onButtonTapAction = { dfs in print("undo")}
        saveButton.onButtonTapAction = { _ in
            self.saveDrawing()
            self.backToLibrary()
        }
        exitButton.onButtonTapAction = { _ in
            self.backToLibrary()
        }
    }
    
	@objc private func openColors() {
		colorsTableView.isHidden.toggle()
		colorButton.isHidden.toggle()
	}
    
    @objc private func saveDrawing() {
        if let imageToSave = mainImageView.image,
           let pngRepresentation = imageToSave.pngData() {
            guard let time = DateToday.currentTime else { return }
            let imageName = "name" + time
            let drawingToSave = Drawing(name: imageName, imageData: pngRepresentation)
            DispatchQueue.global(qos: .background).async {
                StorageService.shared.save(drawing: drawingToSave)
            }
        }
    }
    
    private func backToLibrary() {
        self.navigationController?.popViewController(animated: true)
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
        // TODO: изменять цвет
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
