//
//  FrameInfo.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 01/09/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation

struct FrameInfo: Equatable {
    let isCurrent: Bool
    let frame: Frame
    let runningTotalScore: Score
}
