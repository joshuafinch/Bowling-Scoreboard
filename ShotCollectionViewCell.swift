//
//  ShotCollectionViewCell.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 01/09/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation
import UIKit

final class ShotCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!

    func configure(shot: Shot) {
        label.text = "\(shot.numericValue)"
    }
}
