//
//  PinsKnockedDown.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 01/09/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation

enum PinsKnockedDown: Int {

    /// When the player has knocked down `1...9` pins in a single shot.
    case one = 1, two, three, four, five, six, seven, eight, nine

    /// When the player has knocked down all the pins in a single shot.
    case ten
}
