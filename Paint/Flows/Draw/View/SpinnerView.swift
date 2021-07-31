//
//  SpinnerView.swift
//  Paint
//
//  Created by Илья Мудрый on 31.07.2021.
//

import UIKit

final class SpinnerView: UIView {
    
    // MARK: Properties
    
    private lazy var spinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 1, alpha: 0.7)
        return view
    }()
    
    // MARK: Initialization
    
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
//        setupSpinner()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSpinner()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup Subviews
    
    private func setupSpinner() {
        self.isUserInteractionEnabled = false
        self.addSubview(backgroundView)
        self.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    // MARK: Spinner
    
    public func showSpinner() {
        backgroundView.isHidden = false
        spinner.startAnimating()
    }
    
    public func hideSpinner() {
        backgroundView.isHidden = true
        spinner.stopAnimating()
    }
}
