//
//  FrameHeaderView.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 03/09/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation
import UIKit

final class FrameHeaderView: UICollectionReusableView {

    @IBOutlet weak var label: UILabel!

    func configure(text: String) {
        label.text = text
    }
}
