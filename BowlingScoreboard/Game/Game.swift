//
//  Game.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 29/08/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation

protocol GameDelegate: class {

    func currentPlayerDidChange()

    func gameFinished()

    func availableShotsDidChange(toShots: [ShotScore])

}

final class Game {

    // MARK: - Properties

    /// The date when the game started
    let startDate: Date

    /// The players of the current game, and the shots/scores in their frames
    let players: [PlayerFrames]

    /// The player who's currently taking a turn
    private(set) var currentPlayer: PlayerFrames

    weak var delegate: GameDelegate?

    // MARK: - Initialization

    init?(players: [PlayerFrames], startDate: Date = Date(timeIntervalSinceNow: 0)) {

        self.startDate = startDate
        self.players = players

        guard let currentPlayer = Game.currentPlayersTurn(players: players) else {
            return nil
        }

        self.currentPlayer = currentPlayer
    }

    // MARK: - Public

    /// Returns true if all shots in all frames for all players have been taken
    func isComplete() -> Bool {
        return !players.contains { !$0.frames.allNecessaryShotsTaken() }
    }

    func takeShot(shotScore: ShotScore) throws {
        try currentPlayer.frames.takeShot(shotScore: shotScore)
    }

    func availableShots() -> [ShotScore] {
        let (_, currentFrame) = currentPlayer.frames.currentFrame()
        return currentFrame.availableShots()
    }

    // MARK: - Private

    private static func currentPlayersTurn(players: [PlayerFrames]) -> PlayerFrames? {

        guard let firstPlayer = players.first else {
            return nil
        }

        let (firstPlayerFrameIndex, firstPlayerFrame) = firstPlayer.frames.currentFrame()
        var current: (player: PlayerFrames, frameIndex: Int, frame: Frame) = (firstPlayer,
                                                                              firstPlayerFrameIndex,
                                                                              firstPlayerFrame)

        for player in players {
            let (frameIndex, frame) = player.frames.currentFrame()

            if frameIndex <= current.frameIndex {
                if current.frame.allNecessaryShotsTaken() && !frame.allNecessaryShotsTaken() {
                    current = (player, frameIndex, frame)
                }
            }
        }

        return current.player
    }
}
