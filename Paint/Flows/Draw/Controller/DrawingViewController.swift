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
        tableView.bounces = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "colorCell")
        return tableView
    }()
    
    // TODO: colors
    var colors: [UIColor] = [.red, .cyan, .yellow, .blue, .green, .black, .brown, .magenta, .systemPink, .orange ,.gray ,.purple]
    
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
		view.backgroundColor = .green
		view.addSubview(saveButton)
		view.addSubview(undoButton)
        view.addSubview(colorButton)
        view.addSubview(colorsTableView)
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
	}
	
	private func setupActions() {
		undoButton.onButtonTapAction = { dfs in print("undo")}
		saveButton.onButtonTapAction = { dfs in print("save")}
	}
    
    // TODO: Show hide colors
    @objc private func openColors() {
        print("show / hide colors")
        colorsTableView.isHidden.toggle()
        colorButton.isHidden.toggle()
    }
}

// MARK: Extension DrawingViewController
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
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        colorButton.backgroundColor = colors[indexPath.row]
        openColors()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UITableViewCell {
    open override func layoutSubviews() {
        super.layoutSubviews()
        let padding = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
//        self.frame = self.frame.inset(by: padding)
    }
}
