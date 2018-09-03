//
//  GameTurnTests.swift
//  BowlingScoreboardTests
//
//  Created by Joshua Finch on 03/09/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation
import XCTest
@testable import BowlingScoreboard

final class TwoPlayerGameTurnTests: XCTestCase {

    let playerOne = Player(name: "Player One")
    let playerTwo = Player(name: "Player Two")

    func testNoTurnsPlayed_FirstTurnGoesToFirstPlayer() {
        let playerOneFrames = PlayerFrames(player: playerOne, frames: FrameCollection()!)
        let playerTwoFrames = PlayerFrames(player: playerTwo, frames: FrameCollection()!)
        guard let game = Game(players: [playerOneFrames, playerTwoFrames]) else {
            XCTFail("Game couldn't be created")
            return
        }

        XCTAssertEqual(game.currentPlayer.player, playerOne)
    }

    func testFirstPlayerScoresStrike_ChangesToSecondPlayer() {
        let playerOneFrames = PlayerFrames(player: playerOne, frames: FrameCollection()!)
        let playerTwoFrames = PlayerFrames(player: playerTwo, frames: FrameCollection()!)
        guard let game = Game(players: [playerOneFrames, playerTwoFrames]) else {
            XCTFail("Game couldn't be created")
            return
        }

        XCTAssertEqual(game.currentPlayer.player, playerOne)

        XCTAssertNoThrow(try game.take(shot: .strike))

        XCTAssertEqual(game.currentPlayer.player, playerTwo)
    }

    func testSecondPlayerScoresStrike_ChangesBackToFirstPlayer() {
        let playerOneFrames = PlayerFrames(player: playerOne, frames: FrameCollection()!)
        let playerTwoFrames = PlayerFrames(player: playerTwo, frames: FrameCollection()!)
        guard let game = Game(players: [playerOneFrames, playerTwoFrames]) else {
            XCTFail("Game couldn't be created")
            return
        }

        XCTAssertEqual(game.currentPlayer.player, playerOne)
        XCTAssertNoThrow(try game.take(shot: .strike))
        XCTAssertEqual(game.currentPlayer.player, playerTwo)

        XCTAssertNoThrow(try game.take(shot: .strike))
        XCTAssertEqual(game.currentPlayer.player, playerOne)
    }

    func testThirdTurn_ScoresStrike_ChangesBackToSecondPlayer() {
        let playerOneFrames = PlayerFrames(player: playerOne, frames: FrameCollection()!)
        let playerTwoFrames = PlayerFrames(player: playerTwo, frames: FrameCollection()!)
        guard let game = Game(players: [playerOneFrames, playerTwoFrames]) else {
            XCTFail("Game couldn't be created")
            return
        }

        XCTAssertEqual(game.currentPlayer.player, playerOne)
        XCTAssertNoThrow(try game.take(shot: .strike))
        XCTAssertEqual(game.currentPlayer.player, playerTwo)

        XCTAssertNoThrow(try game.take(shot: .strike))
        XCTAssertEqual(game.currentPlayer.player, playerOne)

        XCTAssertNoThrow(try game.take(shot: .strike))
        XCTAssertEqual(game.currentPlayer.player, playerTwo)
    }

    func testFirstPlayer_MissesFirstShot_StaysOnFirstPlayerForSecondShot() {
        let playerOneFrames = PlayerFrames(player: playerOne, frames: FrameCollection()!)
        let playerTwoFrames = PlayerFrames(player: playerTwo, frames: FrameCollection()!)
        guard let game = Game(players: [playerOneFrames, playerTwoFrames]) else {
            XCTFail("Game couldn't be created")
            return
        }

        XCTAssertEqual(game.currentPlayer.player, playerOne)
        XCTAssertNoThrow(try game.take(shot: .none))
        XCTAssertEqual(game.currentPlayer.player, playerOne)
    }

    func testFirstPlayer_MissesFirstShotScoresSecondShot_ChangesToSecondPlayer() {
        let playerOneFrames = PlayerFrames(player: playerOne, frames: FrameCollection()!)
        let playerTwoFrames = PlayerFrames(player: playerTwo, frames: FrameCollection()!)
        guard let game = Game(players: [playerOneFrames, playerTwoFrames]) else {
            XCTFail("Game couldn't be created")
            return
        }

        XCTAssertEqual(game.currentPlayer.player, playerOne)
        XCTAssertNoThrow(try game.take(shot: .none))
        XCTAssertEqual(game.currentPlayer.player, playerOne)
        XCTAssertNoThrow(try game.take(shot: .three))
        XCTAssertEqual(game.currentPlayer.player, playerTwo)
    }

    func testSecondPlayer_MissesFirstShotScoresSecondShot_ChangesBackToFirstPlayer() {
        let playerOneFrames = PlayerFrames(player: playerOne, frames: FrameCollection()!)
        let playerTwoFrames = PlayerFrames(player: playerTwo, frames: FrameCollection()!)
        guard let game = Game(players: [playerOneFrames, playerTwoFrames]) else {
            XCTFail("Game couldn't be created")
            return
        }

        XCTAssertEqual(game.currentPlayer.player, playerOne)
        XCTAssertNoThrow(try game.take(shot: .none))
        XCTAssertEqual(game.currentPlayer.player, playerOne)
        XCTAssertNoThrow(try game.take(shot: .three))
        XCTAssertEqual(game.currentPlayer.player, playerTwo)

        XCTAssertNoThrow(try game.take(shot: .five))
        XCTAssertEqual(game.currentPlayer.player, playerTwo)
        XCTAssertNoThrow(try game.take(shot: .spare(pinsKnockedDown: .five)))
        XCTAssertEqual(game.currentPlayer.player, playerOne)
    }
}

final class OnePlayerGameTurnTests: XCTestCase {

    let playerOne = Player(name: "Player One")

    func testNoTurnsPlayed_FirstTurnGoesToFirstPlayer() {
        let playerOneFrames = PlayerFrames(player: playerOne, frames: FrameCollection()!)
        guard let game = Game(players: [playerOneFrames]) else {
            XCTFail("Game couldn't be created")
            return
        }

        XCTAssertEqual(game.currentPlayer.player, playerOne)
    }

    func testFirstShotTaken_RemainsOnFirstPlayer() {
        let playerOneFrames = PlayerFrames(player: playerOne, frames: FrameCollection()!)
        guard let game = Game(players: [playerOneFrames]) else {
            XCTFail("Game couldn't be created")
            return
        }

        XCTAssertEqual(game.currentPlayer.player, playerOne)

        XCTAssertNoThrow(try game.take(shot: .none))
        XCTAssertEqual(game.currentPlayer.player, playerOne)
    }
}
