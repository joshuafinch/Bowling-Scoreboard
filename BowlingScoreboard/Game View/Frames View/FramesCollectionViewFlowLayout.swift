//
//  FramesCollectionViewFlowLayout.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 01/09/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation
import UIKit

final class FramesCollectionViewFlowLayout: UICollectionViewLayout {

    struct Constants {
        static let itemSize: CGSize = CGSize(width: 55, height: 60)
        static let itemSpacing: CGFloat = 4
        static let lineSpacing: CGFloat = 4
    }

    // MARK: - Properties

    private var attributeCache: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    private var contentSize: CGSize = .zero

    // MARK: - UICollectionViewFlowLayout

    override var collectionViewContentSize: CGSize {
        return contentSize
    }

    override func prepare() {
        attributeCache = [:]
        contentSize = calculateContentSize()
        super.prepare()
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        guard let collectionView = collectionView else { return nil }

        var elementsInRect = [UICollectionViewLayoutAttributes]()

        for section in 0..<collectionView.numberOfSections {
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)

                let attributes = [
                    layoutAttributesForItem(at: indexPath),
                    layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: indexPath),
                    layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionFooter, at: indexPath)
                    ]
                    .compactMap({ $0 })
                    .filter({
                        $0.frame.intersects(rect)
                    })

                elementsInRect.append(contentsOf: attributes)
            }
        }

        return elementsInRect
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

        if let cachedAttributes = attributeCache[indexPath] {
            return cachedAttributes
        }

        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        var frame = attributes.frame
        frame.size.width = Constants.itemSize.width
        frame.size.height = Constants.itemSize.height
        frame.origin.x = (frame.width + Constants.itemSpacing) * CGFloat(indexPath.item)
        frame.origin.y = (frame.height + Constants.lineSpacing) * CGFloat(indexPath.section)
        attributes.frame = frame
        attributeCache[attributes.indexPath] = attributes

        return attributeCache[indexPath]
    }

    // MARK: - Private

    private func calculateContentSize() -> CGSize {
        guard let collectionView = collectionView else {
            return .zero
        }

        let numberOfSections = collectionView.numberOfSections
        guard numberOfSections > 0 else {
            return .zero
        }

        var maxItems = 0
        for section in 0..<numberOfSections {
            maxItems = max(maxItems, collectionView.numberOfItems(inSection: section))
        }

        guard maxItems > 0 else {
            return .zero
        }

        let maxWidth = (Constants.itemSize.width + Constants.itemSpacing) * CGFloat(maxItems)
        let maxHeight = (Constants.itemSize.height + Constants.lineSpacing) * CGFloat(numberOfSections)
        return CGSize(width: maxWidth, height: maxHeight)
    }
}
