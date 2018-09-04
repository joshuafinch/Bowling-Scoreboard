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
        static let itemSize: CGSize = CGSize(width: 50, height: 55)
        static let itemSpacing: CGFloat = 2

        static let frameHeaderSize: CGSize = CGSize(width: 50, height: 20)
        static let frameHeaderKind: String = "frameHeaderKind"

        static let lineSpacing: CGFloat = 0
        static let sectionSpacing: CGFloat = 2
    }

    // MARK: - Properties

    private var attributeCache: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    private var supplementaryAttributeCache: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    private var contentSize: CGSize = .zero

    // MARK: - UICollectionViewFlowLayout

    override var collectionViewContentSize: CGSize {
        return contentSize
    }

    override func prepare() {
        attributeCache = [:]
        supplementaryAttributeCache = [:]
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
                    layoutAttributesForSupplementaryView(ofKind: Constants.frameHeaderKind, at: indexPath)
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
        frame.origin.y = ((frame.height + Constants.sectionSpacing) * CGFloat(indexPath.section))
            + (Constants.frameHeaderSize.height * CGFloat(indexPath.section + 1))
        attributes.frame = frame
        attributeCache[attributes.indexPath] = attributes

        return attributeCache[indexPath]
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

        guard elementKind == Constants.frameHeaderKind else {
            // Only support frameHeaderKinds in this layout
            return nil
        }

        if let cachedAttributes = supplementaryAttributeCache[indexPath] {
            return cachedAttributes
        }

        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)

        var frame = attributes.frame
        frame.size.width = Constants.frameHeaderSize.width
        frame.size.height = Constants.frameHeaderSize.height
        frame.origin.x = (frame.width + Constants.itemSpacing) * CGFloat(indexPath.item)
        frame.origin.y = (frame.height + Constants.itemSize.height + Constants.sectionSpacing) * CGFloat(indexPath.section)
        attributes.frame = frame

        supplementaryAttributeCache[attributes.indexPath] = attributes

        return supplementaryAttributeCache[indexPath]
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
        let maxHeight = (Constants.itemSize.height + Constants.frameHeaderSize.height) * CGFloat(numberOfSections)
            + (Constants.sectionSpacing * CGFloat(numberOfSections - 1))
        return CGSize(width: maxWidth, height: maxHeight)
    }
}
