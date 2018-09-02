//
//  Shot.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 29/08/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation

/// The player's score for a single shot within a `Frame`, not taking into account bonuses for strikes and spares
enum Shot: Equatable {

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

extension Shot: Codable {

    enum CodingError: Error {
        case decoding(String)
    }

    enum CodingKeys: String, CodingKey {
        case other
        case spare
    }

    // swiftlint:disable:next cyclomatic_complexity
    init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)

        if let pins = try values.decodeIfPresent(Int.self, forKey: .spare),
            let pinsKnockedDown = PinsKnockedDown(rawValue: pins) {
            self = .spare(pinsKnockedDown: pinsKnockedDown)
            return
        }

        if let pins = try values.decodeIfPresent(Int.self, forKey: .other) {
            switch pins {
            case 0: self = .none
            case 1: self = .one
            case 2: self = .two
            case 3: self = .three
            case 4: self = .four
            case 5: self = .five
            case 6: self = .six
            case 7: self = .seven
            case 8: self = .eight
            case 9: self = .nine
            case 10: self = .strike
            default: throw CodingError.decoding("Decoding other failed. \(dump(values))")
            }
            return
        }

        throw CodingError.decoding("Decoding Failed. \(dump(values))")
    }

    // swiftlint:disable:next cyclomatic_complexity
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .spare(let pinsKnockedDown): try container.encode(pinsKnockedDown.rawValue, forKey: .spare)
        case .none: try container.encode(0, forKey: .other)
        case .one: try container.encode(1, forKey: .other)
        case .two: try container.encode(2, forKey: .other)
        case .three: try container.encode(3, forKey: .other)
        case .four: try container.encode(4, forKey: .other)
        case .five: try container.encode(5, forKey: .other)
        case .six: try container.encode(6, forKey: .other)
        case .seven: try container.encode(7, forKey: .other)
        case .eight: try container.encode(8, forKey: .other)
        case .nine: try container.encode(9, forKey: .other)
        case .strike: try container.encode(10, forKey: .other)
        }
    }
}
