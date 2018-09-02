//
//  FrameCollectionViewCell.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 01/09/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation
import UIKit

final class FrameCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var firstShotView: UIView!
    @IBOutlet weak var secondShotView: UIView!
    @IBOutlet weak var thirdShotView: UIView!

    @IBOutlet weak var firstShotLabel: UILabel!
    @IBOutlet weak var secondShotLabel: UILabel!
    @IBOutlet weak var thirdShotLabel: UILabel!

    @IBOutlet weak var runningTotalView: UIView!
    @IBOutlet weak var runningTotalLabel: UILabel!

    func configure(frame: FrameViewModel) {
        runningTotalLabel.text = frame.runningTotal
        firstShotLabel.text = frame.firstShot
        secondShotLabel.text = frame.secondShot
        thirdShotLabel.text = frame.thirdShot
    }
}
