//
//  FrameViewModel.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 01/09/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation

struct FrameViewModel {
    let firstShot: String?
    let secondShot: String?
    let thirdShot: String?
    let runningTotal: String?

    init(frameInfo info: FrameInfo) {
        runningTotal = !info.frame.shots.isEmpty ? "\(info.runningTotalScore)" : nil

        let shots = info.frame.shots

        switch shots.count {
        case 1:
            firstShot = nil
            secondShot = ShotViewModel(shot: shots[0]).string
            thirdShot = nil
        case 2:
            firstShot = nil
            secondShot = ShotViewModel(shot: shots[0]).string
            thirdShot = ShotViewModel(shot: shots[1]).string
        case 3:
            firstShot = ShotViewModel(shot: shots[0]).string
            secondShot = ShotViewModel(shot: shots[1]).string
            thirdShot = ShotViewModel(shot: shots[2]).string
        default:
            firstShot = nil
            secondShot = nil
            thirdShot = nil
        }
    }
}
