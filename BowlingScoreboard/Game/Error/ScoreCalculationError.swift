//
//  ScoreCalculationError.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 29/08/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation

enum ScoreCalculationError: LocalizedError {

    case tooManyShotsInSingleFrame
    case spareOnFirstShot
    case strikeOnSecondShotInNonFinalFrame
    case spareKnockedDownMorePinsThanAvailable
    case spareDidNotKnockDownRemainingPins
    case secondShotShouldHaveBeenSpare
    case thirdShotShouldHaveBeenSpare
    case knockedDownMorePinsThanAvailable

    var errorDescription: String? {
        switch self {
        case .tooManyShotsInSingleFrame:
            return "Too many shots in a single frame"
        case .spareOnFirstShot:
            return "Cannot have a spare on the first shot of a frame"
        case .strikeOnSecondShotInNonFinalFrame:
            return "Cannot have a strike on the second shot of a non-final frame"
        case .spareKnockedDownMorePinsThanAvailable:
            return "Cannot have a spare with pins knocked down greater than what was available at the end of last shot"
        case .spareDidNotKnockDownRemainingPins:
            return "Cannot have a spare without remaining pins from last shot being knocked down"
        case .secondShotShouldHaveBeenSpare:
            return "Cannot have the first and second shot totalling 10, without the second shot being declared a spare"
        case .thirdShotShouldHaveBeenSpare:
            return "Third shot should have been a spare"
        case .knockedDownMorePinsThanAvailable:
            return "Cannot have the shots knocking down more pins than available to knock down"
        }
    }
}
