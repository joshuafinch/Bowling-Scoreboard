//
//  PlayerFrames.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 29/08/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation

struct PlayerFrames: Equatable {

    let player: Player
    let frames: FrameCollection
}

extension PlayerFrames: Codable {

    private enum CodingError: Error {
        case decoding(String)
    }

    private enum CodingKeys: String, CodingKey {
        case player
        case frames
    }

    init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)

        guard let player = try? values.decode(Player.self, forKey: .player),
            let frames = try? values.decode([Frame].self, forKey: .frames) else {
            throw CodingError.decoding("Decoding Failed. \(dump(values))")
        }

        guard let frameCollection = FrameCollection(frames: frames) else {
            throw CodingError.decoding("Decoding Failed (frames couldn't be converted to a FrameCollection). \(dump(values))")
        }

        self.init(player: player, frames: frameCollection)
    }

    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(player, forKey: .player)
        try container.encode(frames.frames, forKey: .frames)
    }
}
