//
//  AvailableShotsControl.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 01/09/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation
import UIKit

final class AvailableShotsCollectionViewController: UICollectionViewController {

    // MARK: - Properties

    var shots: [Shot] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }

    private let shotCellReuseIdentifier = "shotCellReuseIdentifier"

    // MARK: - Initialization

    convenience init() {
        self.init(collectionViewLayout: CenterCollectionViewFlowLayout())
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let collectionView = collectionView else {
            fatalError("Collection view was not set")
        }

        guard let collectionViewLayout = collectionViewLayout as? CenterCollectionViewFlowLayout else {
            fatalError("Collection view layout was not set to CenterCollectionViewFlowLayout")
        }

        collectionView.backgroundColor = .white
        collectionView.delegate = self

        let nib = UINib(nibName: "ShotCollectionViewCell", bundle: .main)
        collectionView.register(nib, forCellWithReuseIdentifier: shotCellReuseIdentifier)

        collectionViewLayout.minimumInteritemSpacing = 15
        collectionViewLayout.minimumLineSpacing = 15
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shots.count
    }

    // MARK: - UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: shotCellReuseIdentifier,
                                                            for: indexPath) as? ShotCollectionViewCell else {
            fatalError("Couldn't dequeue cell of type ShotCollectionViewCell")
        }

        let shot = shots[indexPath.row]
        cell.configure(shot: shot)
        return cell
    }
}
