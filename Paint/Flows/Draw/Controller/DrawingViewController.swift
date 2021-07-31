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
	private let toolsImages: [UIImage?] = [UIImage(named: "pencil"), UIImage(named: "line"),
										   UIImage(named: "rectangle"), UIImage(named: "ellipse"),
										   UIImage(named: "triangle")]
	
	private lazy var mainView: DrawingView = {
		let view = DrawingView()
		return view
	}()
	
	// MARK: Color Picker
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
    
    private lazy var spinner: SpinnerView = {
        let view = SpinnerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
	private let colors: [UIColor] = [.black, .gray, .red, .orange, .yellow, .green, .cyan, .blue, .magenta, .purple, .brown]
    
    // MARK: - Initialization
    
    convenience init() {
        self.init(withDrawing: nil)
    }
    
	init(withDrawing drawing: Drawing?) {
		super.init(nibName: nil, bundle: nil)
		guard
			let drawing = drawing,
			let image = UIImage(data: drawing.imageData)
		else { return }
		self.currentName = drawing.name
		self.openImage(with: image)
	}
    
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		addSubviews()
		setupConstraints()
		setupActions()
	}
	
	override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		mainView.colorButton.setBackgroundColor(colors.first)
		navigationController?.setNavigationBarHidden(true, animated: false)
		changeCollectionViewEdgeInsets()
	}
	
	// MARK: - Setup
	
	private func addSubviews() {
		view.addSubview(mainView)
		view.addSubview(colorsTableView)
		view.addSubview(toolsCollectionView)
		view.addSubview(leftGradientView)
		view.addSubview(rightGradientView)
        view.addSubview(spinner)
	}
	
	private func setupConstraints() {
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
		
		NSLayoutConstraint.activate([
			mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
        
        NSLayoutConstraint.activate([
            spinner.topAnchor.constraint(equalTo: view.topAnchor),
            spinner.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            spinner.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            spinner.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
	}
	
    // MARK: Button Actions
	private func setupActions() {
		mainView.undoButton.onButtonTapAction = { [weak self] _ in
			self?.undoButtonTapped()
		}
		
		mainView.saveButton.onButtonTapAction = { [weak self] _ in
			self?.showNameAlertController()
		}
		
		mainView.exitButton.onButtonTapAction = { [weak self] _ in
			self?.backToLibrary()
		}
		
		mainView.colorButton.onButtonTapAction = { [weak self] _ in
			self?.openColors()
		}
	}
	
	private func openColors() {
		colorsTableView.isHidden.toggle()
		mainView.colorButton.setAnotherHidden()
	}
	
	private func changeCollectionViewEdgeInsets() {
		let sideInset = (self.view.frame.width / 2) - 30
		self.toolsCollectionView.contentInset = UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
	}
	
	private func saveDrawing(drawingName: String, completion: ()->()) {
		guard
			let imageToSave = mainImageView.image,
		else { return }
		let drawingToSave = Drawing(name: drawingName, imageData: pngRepresentation)
		StorageService().save(drawing: drawingToSave, completion: completion)
	}
	
	private func backToLibrary() {
		self.navigationController?.popViewController(animated: true)
	}
	
	private func showNameAlertController() {
		
		nameAlertController.addTextField { [weak self] (textField: UITextField) in
			textField.text = self?.currentName ?? ""
			textField.clearButtonMode = .whileEditing
		}
		
		let saveAndReturnAction = UIAlertAction(title: "Сохранить", style: .default) { [weak self] _ in
            guard
				let self = self,
				var drawingName = nameAlertController.textFields?.first?.text
			else { return }
			if drawingName == "" { drawingName = "IMG\(StorageService().count() + 1)" }
			let pngRepresentation = imageToSave.pngData()
        let nameAlertController = UIAlertController(title: "Сохранить как:", message: nil, preferredStyle: .alert)
            textField.placeholder = "IMG\(StorageService().count() + 1)"
            self.spinner.showSpinner()
            self.saveDrawing(drawingName: drawingName, completion: self.backToLibrary)
            self.spinner.hideSpinner()
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        nameAlertController.addAction(saveAndReturnAction)
        nameAlertController.addAction(cancelAction)
        
        self.navigationController?.present(nameAlertController, animated: true, completion: nil)
    }
}

// MARK: - Extension TableView Delegate
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
		mainView.colorButton.backgroundColor = colors[indexPath.row]
        setLineColor(colors[indexPath.row])
        openColors()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Extension CollectionView Delegate
extension DrawingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return tools.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "toolsCell", for: indexPath) as? ToolsCollectionViewCell else { return UICollectionViewCell() }
		cell.setImage(image: toolsImages[indexPath.row] ?? UIImage())
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
            setPickedTool(tools[indexPath.row])
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

// MARK: - Hide Elements While Drawing
extension DrawingViewController {
    
    private func hideButtons() {
        exitButton.isHidden = true
        undoButton.isHidden = true
        saveButton.isHidden = true
        colorButton.isHidden = true
        toolsCollectionView.isHidden = true
        leftGradientView.isHidden = true
        rightGradientView.isHidden = true
    }
    
    private func showButtons() {
        exitButton.isHidden = false
        undoButton.isHidden = false
        saveButton.isHidden = false
        colorButton.isHidden = false
        toolsCollectionView.isHidden = false
        leftGradientView.isHidden = false
        rightGradientView.isHidden = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.hideButtons()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
            self?.showButtons()
        }
    }
}
