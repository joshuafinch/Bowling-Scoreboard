//
//  CenterCollectionViewFlowLayout.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 01/09/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation
import UIKit

class CenterCollectionViewFlowLayout: UICollectionViewFlowLayout {

    // MARK: - Properties

    private var attributeCache: [IndexPath: UICollectionViewLayoutAttributes] = [:]

    // MARK: - UICollectionViewFlowLayout

    override func prepare() {
        attributeCache = [:]
        super.prepare()
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        guard let collectionView = collectionView else { return nil }

        var updatedAttributes = [UICollectionViewLayoutAttributes]()

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

                updatedAttributes.append(contentsOf: attributes)
            }
        }

        return updatedAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

        guard let collectionView = collectionView else {
            return nil
        }

        if let cachedAttributes = attributeCache[indexPath] {
            return cachedAttributes
        }

        let itemsInSection = collectionView.numberOfItems(inSection: indexPath.section)

        let collectionViewWidth = collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right

        let itemsInSameRow = findItems(onSameRowAs: indexPath, itemsInSection: itemsInSection, collectionViewWidth: collectionViewWidth)

        var interimSpacing = minimumInteritemSpacing

        if let flowDelegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout {
            if !itemsInSameRow.isEmpty {
                interimSpacing = flowDelegate.collectionView!(collectionView,
                                                              layout: self,
                                                              minimumInteritemSpacingForSectionAt: indexPath.section)
            }
        }

        let aggregateInterimSpacing = interimSpacing * CGFloat(itemsInSameRow.count-1)

        let aggregateItemWidth: CGFloat = itemsInSameRow.reduce(into: 0) { (result, attributes) in
            result += attributes.frame.width
        }

        let alignmentWidth = aggregateItemWidth + aggregateInterimSpacing
        let alignmentXOffset = (collectionViewWidth - alignmentWidth) * 0.5

        var previousFrame = CGRect.zero
        for attributes in itemsInSameRow {
            var frame = attributes.frame
            if previousFrame.equalTo(.zero) {
                frame.origin.x = alignmentXOffset
            } else {
                frame.origin.x = previousFrame.maxX + interimSpacing
            }
            attributes.frame = frame
            previousFrame = frame
            attributeCache[attributes.indexPath] = attributes
        }

        return attributeCache[indexPath]
    }

    // MARK: - Private

    private func findItems(onSameRowAs indexPath: IndexPath, itemsInSection: Int, collectionViewWidth: CGFloat) -> [UICollectionViewLayoutAttributes] {

        var itemsOnSameRow = [UICollectionViewLayoutAttributes]()

        // Create a frame that spans the entire row to check intersections against
        guard var rowTestFrame = super.layoutAttributesForItem(at: indexPath)?.frame else {
            return []
        }
        rowTestFrame.origin.x = 0
        rowTestFrame.size.width = collectionViewWidth

        var firstItemIndex = indexPath.row

        // Find the first item that is in this row
        for itemIndex in stride(from: firstItemIndex, to: 0, by: 1) {
            let indexPath = IndexPath(row: itemIndex, section: indexPath.section)
            if let frame = super.layoutAttributesForItem(at: indexPath)?.frame {
                if frame.intersects(rowTestFrame) {
                    // Is in the same row
                    firstItemIndex = indexPath.item
                    continue
                } else {
                    // Found the previous row
                    break
                }
            }
        }

        var lastItemIndex = firstItemIndex

        // Iterate until we find the last item that is in this row
        // and add all items found in the same row to our array
        for itemIndex in lastItemIndex..<itemsInSection {
            let indexPath = IndexPath(row: itemIndex, section: indexPath.section)
            if let attributes = super.layoutAttributesForItem(at: indexPath) {
                if attributes.frame.intersects(rowTestFrame) {
                    // Is in the same row
                    lastItemIndex = indexPath.item
                    itemsOnSameRow.append(attributes)
                    continue
                } else {
                    // Found the next row
                    break
                }
            }
        }

        return itemsOnSameRow
    }
}
