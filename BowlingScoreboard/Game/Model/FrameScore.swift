//
//  FrameScore.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 01/09/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation

typealias Score = Int

struct FrameScore {

    let frame: Frame
    let frameScore: Score
    let runningTotalScore: Score

    init(frame: Frame, frameScore: Score = 0, runningTotalScore: Score = 0) {
        self.frame = frame
        self.frameScore = frameScore
        self.runningTotalScore = runningTotalScore
    }
}
