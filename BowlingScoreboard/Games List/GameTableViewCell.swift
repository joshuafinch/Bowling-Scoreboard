//
//  GameTableViewCell.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 03/09/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation
import UIKit

final class GameTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!

    func configure(viewModel: GameCellViewModel) {
        dateLabel.text = viewModel.date
    }
}
