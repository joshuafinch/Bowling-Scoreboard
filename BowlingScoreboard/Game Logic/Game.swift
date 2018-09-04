//
//  Game.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 29/08/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation

final class Game {

    // MARK: - Properties

    /// Unique Identifier
    let identifier: UUID

    /// The date when the game started
    let startDate: Date

    /// The players of the current game, and the shots/scores in their frames
    let players: [PlayerFrames]

    /// The player who's currently taking a turn
    private(set) var currentPlayer: PlayerFrames

    weak var delegate: GameDelegate?

    // MARK: - Initialization

    init?(players: [PlayerFrames], startDate: Date = Date(timeIntervalSinceNow: 0), identifier: UUID = UUID()) {

        self.startDate = startDate
        self.players = players
        self.identifier = identifier

        guard let currentPlayer = Game.currentPlayersTurn(players: players) else {
            return nil
        }

        self.currentPlayer = currentPlayer
    }

    convenience init?(gameData: GameData) {
        guard let startDate = gameData.startDate, let playersFramesData = gameData.playersFrames, let identifier = gameData.identifier else {
            return nil
        }

        guard let playerFrames = try? PropertyListDecoder().decode([PlayerFrames].self, from: playersFramesData) else {
            return nil
        }

        self.init(players: playerFrames, startDate: startDate, identifier: identifier)
    }

    // MARK: - Public

    /// Returns true if all shots in all frames for all players have been taken
    func isComplete() -> Bool {
        return !players.contains { !$0.frames.allNecessaryShotsTaken() }
    }

    enum Winner {
        case player(Player, Int)
        case draw(Int)
    }

    func winner() -> Winner? {
        guard isComplete() else {
            return nil
        }

        let playerTotals = zip(players, players.map({ $0.frames.runningTotalScore() }))
        let sortedPlayerTotals = playerTotals.sorted {
            $0.1 > $1.1
        }

        if sortedPlayerTotals.count > 1 {
            if sortedPlayerTotals[0].1 == sortedPlayerTotals[1].1 {
                return .draw(sortedPlayerTotals[0].1)
            }
        }

        return .player(sortedPlayerTotals[0].0.player, sortedPlayerTotals[0].1)
    }

    func take(shot: Shot) throws {
        checkCurrentPlayer()
        try currentPlayer.frames.take(shot: shot)
        checkCurrentPlayer()

        delegate?.framesDidChange(toPlayerFrames: players)
        delegate?.availableShotsDidChange(toShots: availableShots())

        if isComplete() {
            delegate?.gameFinished()
        }
    }

    func availableShots() -> [Shot] {
        let (_, currentFrame) = currentPlayer.frames.currentFrame()
        return currentFrame.availableShots()
    }

    private func checkCurrentPlayer() {
        if let nextPlayer = Game.currentPlayersTurn(players: players) {
            if nextPlayer != currentPlayer {
                currentPlayer = nextPlayer
                delegate?.currentPlayerDidChange()
            }
        }
    }

    // MARK: - Private

    private static func currentPlayersTurn(players: [PlayerFrames]) -> PlayerFrames? {

        guard !players.isEmpty else {
            return nil
        }

        var players = players
        let firstPlayer = players.removeFirst()
        let (firstPlayerFrameIndex, firstPlayerFrame) = firstPlayer.frames.currentFrame()

        var current: (player: PlayerFrames, frameIndex: Int, frame: Frame) = (firstPlayer,
                                                                              firstPlayerFrameIndex,
                                                                              firstPlayerFrame)

        for player in players {
            let (frameIndex, frame) = player.frames.currentFrame()

            if current.frame.allNecessaryShotsTaken() {
                current = (player, frameIndex, frame)
            } else if frameIndex < current.frameIndex && !frame.allNecessaryShotsTaken() {
                current = (player, frameIndex, frame)
            }
        }

        return current.player
    }
}
