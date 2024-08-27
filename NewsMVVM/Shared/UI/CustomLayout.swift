//
//  CustomLayout.swift
//  ProductsGallery
//
//  Created by Mangust on 10.08.2024.
//

import UIKit

final class CustomLayout: UICollectionViewCompositionalLayout {

    init(
        interItemSpacing: CGFloat = Constants.defaultInterItemSpacing,
        scrollDirection: UICollectionView.ScrollDirection = .vertical,
        itemHeight: CGFloat = Constants.defaultItemHeight +  Constants.estimatedItemHeightOffset
    ) {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = scrollDirection

        super.init(sectionProvider: { sectionIndex, env in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: Constants.itemSizeWidthDimension,
                heightDimension: .estimated(itemHeight)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: Constants.groupSizeWidthDimension,
                heightDimension: .estimated(itemHeight)
            )

            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = interItemSpacing
            
            return section
        }, configuration: config
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate extension CustomLayout {
    enum Constants {
        static let itemSizeWidthDimension: NSCollectionLayoutDimension = .fractionalWidth(1)
        static let groupSizeWidthDimension: NSCollectionLayoutDimension = .fractionalWidth(1)
        static let defaultItemHeight: CGFloat = 80
        static let estimatedItemHeightOffset: CGFloat = 20
        static let defaultInterItemSpacing: CGFloat = 0
    }
}
