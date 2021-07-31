//
//  LibraryCollectionView.swift
//  Paint
//
//  Created by Илья Мудрый on 31.07.2021.
//

import UIKit

class LibraryCollectionView: UICollectionView {

    // MARK: Properties
    
    private let inset: CGFloat = 1.0
    
    // MARK: Initialization
    
    convenience init() {
        self.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        backgroundColor = .white
        setupLibraryLayout()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = .white
        setupLibraryLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Compositional Layout
    
    private func setupLibraryLayout() {
        // Large item
        let largeItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(2/3),
                                                   heightDimension: .fractionalHeight(1))
        let largeItem = NSCollectionLayoutItem(layoutSize: largeItemSize)
        largeItem.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        // Small item
        let smallItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let smallItem = NSCollectionLayoutItem(layoutSize: smallItemSize)
        smallItem.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        // Top line
        let topNestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                        heightDimension: .absolute(Screen.width * 1/3))
        let topNestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: topNestedGroupSize, subitem: smallItem, count: 3)
        
        // Side nested group
        let sideNestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                                          heightDimension: .fractionalHeight(1))
        let sideNestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: sideNestedGroupSize, subitem: smallItem, count: 2)

        // Nested groups
        let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                     heightDimension: .absolute(Screen.width * 2/3))
        let leftNestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: nestedGroupSize,
                                                                  subitems: [largeItem, sideNestedGroup])
        let rightNestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: nestedGroupSize,
                                                                   subitems: [sideNestedGroup, largeItem])
        
        // Common group
        let commonGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                     heightDimension: .absolute(Screen.width * 2))
        let commonGroup = NSCollectionLayoutGroup.vertical(layoutSize: commonGroupSize,
                                                           subitems: [topNestedGroup, leftNestedGroup, topNestedGroup, rightNestedGroup])
        
        // Section
        let section = NSCollectionLayoutSection(group: commonGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        
        let collectionCompositionalLayout = UICollectionViewCompositionalLayout(section: section)
        setCollectionViewLayout(collectionCompositionalLayout, animated: false)
    }
}
