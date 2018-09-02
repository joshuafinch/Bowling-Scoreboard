//
//  ShotViewModel.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 02/09/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation

struct ShotViewModel {

    let string: String

    // swiftlint:disable:next cyclomatic_complexity
    init(shot: Shot) {
        switch shot {
        case .none: string = "-"
        case .one: string = "1"
        case .two: string = "2"
        case .three: string = "3"
        case .four: string = "4"
        case .five: string = "5"
        case .six: string = "6"
        case .seven: string = "7"
        case .eight: string = "8"
        case .nine: string = "9"
        case .spare: string = "/"
        case .strike: string = "X"
        }
    }
}
