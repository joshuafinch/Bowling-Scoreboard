//
//  FramesCollectionViewController.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 01/09/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation
import UIKit

final class FramesCollectionViewController: UICollectionViewController {

    // MARK: - Properties

    var playerFrames: [[FrameViewModel]] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }

    private let frameCellReuseIdentifier = "twoShotFrameCellReuseIdentifier"
    private let frameHeaderReuseIdentifer = "frameHeaderView"

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let collectionView = collectionView else {
            fatalError("Collection view was not set")
        }

        collectionView.backgroundColor = .themeDark
        collectionView.isPagingEnabled = false
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = true

        collectionView.register(UINib(nibName: "FrameCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: frameCellReuseIdentifier)

        collectionView.register(UINib(nibName: "FrameHeaderView", bundle: .main),
                                forSupplementaryViewOfKind: FramesCollectionViewFlowLayout.Constants.frameHeaderKind,
                                withReuseIdentifier: frameHeaderReuseIdentifer)
    }

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return playerFrames.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playerFrames[section].count
    }

    // MARK: - UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let frame = playerFrames[indexPath.section][indexPath.item]

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: frameCellReuseIdentifier, for: indexPath) as? FrameCollectionViewCell else {
            fatalError("Couldn't dequeue the FrameCollectionViewCell")
        }

        cell.configure(frame: frame)

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {

        guard kind == FramesCollectionViewFlowLayout.Constants.frameHeaderKind else {
            fatalError("Other supplementary views are not currently supported")
        }

        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: frameHeaderReuseIdentifer, for: indexPath) as? FrameHeaderView

        view?.configure(text: "F\(indexPath.item + 1)")

        // swiftlint:disable:next force_cast
        return view!
    }
}
