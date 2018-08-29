//
//  TakeShotError.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 01/09/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation

enum TakeShotError: LocalizedError {

    case alreadyTakenNecessaryShotsInThisFrame
    case invalidShot
    case invalidFrameSetup

    var errorDescription: String? {
        switch self {
        case .alreadyTakenNecessaryShotsInThisFrame:
            return "Already taken necessary shots in this frame"
        case .invalidShot:
            return "Invalid shot"
        case .invalidFrameSetup:
            return "Invalid frame setup"
        }
    }
}
