//
//  Shot.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 29/08/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation

/// The player's score for a single shot within a `Frame`, not taking into account bonuses for strikes and spares
enum Shot {

    /// When the player fails to knock down any pins in that shot.
    case none

    /// When the player has knocked down `1...9` pins in a single shot.
    case one, two, three, four, five, six, seven, eight, nine

    /// When the player knocks down the remaining pins on their second shot of the frame.
    case spare(pinsKnockedDown: PinsKnockedDown)

    /// When the player knocks down all pins on their first shot of the frame.
    case strike

    var numericValue: Int {
        switch self {
        case .none: return 0
        case .one: return 1
        case .two: return 2
        case .three: return 3
        case .four: return 4
        case .five: return 5
        case .six: return 6
        case .seven: return 7
        case .eight: return 8
        case .nine: return 9
        case .spare(let pinsKnockedDown): return pinsKnockedDown.rawValue
        case .strike: return 10
        }
    }

    static let all: [Shot] = [
        .none, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine,
        .spare(pinsKnockedDown: .one), .spare(pinsKnockedDown: .two),
        .spare(pinsKnockedDown: .three), .spare(pinsKnockedDown: .four),
        .spare(pinsKnockedDown: .five), .spare(pinsKnockedDown: .six),
        .spare(pinsKnockedDown: .seven), .spare(pinsKnockedDown: .eight),
        .spare(pinsKnockedDown: .nine), .spare(pinsKnockedDown: .ten),
        .strike
    ]
}
