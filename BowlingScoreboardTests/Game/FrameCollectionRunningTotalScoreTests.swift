//
//  FrameCollectionRunningTotalScoreTests.swift
//  BowlingScoreboardTests
//
//  Created by Joshua Finch on 30/08/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation
import XCTest
@testable import BowlingScoreboard

final class FrameCollectionRunningTotalScoreTests: XCTestCase {

    func testRunningTotalScore_WithTenFramesNoShots_ReturnsZero() {
        guard let sut = FrameCollection() else {
            XCTFail("Couldn't prepare test data")
            return
        }

        XCTAssertEqual(sut.runningTotalScore(), 0)
    }

    func testRunningTotalScore_WithTenFramesPlayed_Returns164() {
        let initialFrames = [
            Frame(isFinal: false, shots: [.strike]), // 20
            Frame(isFinal: false, shots: [.one, .spare(pinsKnockedDown: .nine)]), // 12
            Frame(isFinal: false, shots: [.two, .spare(pinsKnockedDown: .eight)]), // 13
            Frame(isFinal: false, shots: [.three, .spare(pinsKnockedDown: .seven)]), // 14
            Frame(isFinal: false, shots: [.four, .spare(pinsKnockedDown: .six)]), // 15
            Frame(isFinal: false, shots: [.five, .spare(pinsKnockedDown: .five)]), // 16
            Frame(isFinal: false, shots: [.six, .spare(pinsKnockedDown: .four)]), // 17
            Frame(isFinal: false, shots: [.seven, .spare(pinsKnockedDown: .three)]), // 18
            Frame(isFinal: false, shots: [.eight, .spare(pinsKnockedDown: .two)]), // 19
            Frame(isFinal: true, shots: [.nine, .spare(pinsKnockedDown: .one), .strike]) // 20
            ].compactMap({$0})
        XCTAssertEqual(initialFrames.count, 10)

        guard let sut = FrameCollection(frames: initialFrames) else {
            XCTFail("Couldn't prepare test data")
            return
        }

        XCTAssertEqual(sut.runningTotalScore(), 20+12+13+14+15+16+17+18+19+20)
    }

    func testRunningTotalScore_With300Series_Returns300() {
        let initialFrames = [
            Frame(isFinal: false, shots: [.strike]), // 30
            Frame(isFinal: false, shots: [.strike]), // 30
            Frame(isFinal: false, shots: [.strike]), // 30
            Frame(isFinal: false, shots: [.strike]), // 30
            Frame(isFinal: false, shots: [.strike]), // 30
            Frame(isFinal: false, shots: [.strike]), // 30
            Frame(isFinal: false, shots: [.strike]), // 30
            Frame(isFinal: false, shots: [.strike]), // 30
            Frame(isFinal: false, shots: [.strike]), // 30
            Frame(isFinal: true, shots: [.strike, .strike, .strike]) // 30
            ].compactMap({$0})
        XCTAssertEqual(initialFrames.count, 10)

        guard let sut = FrameCollection(frames: initialFrames) else {
            XCTFail("Couldn't prepare test data")
            return
        }

        XCTAssertEqual(sut.runningTotalScore(), 300)
    }

    func testRunningTotalScore_WithoutFinalFrameFinished_ReturnsScore() {
        let initialFrames = [
            Frame(isFinal: false, shots: [.strike]), // 13
            Frame(isFinal: false, shots: [.one, .two]), // 3
            Frame(isFinal: false, shots: [.three, .four]), // 7
            Frame(isFinal: false, shots: [.five, .four]), // 9
            Frame(isFinal: false, shots: [.six, .one]), // 7
            Frame(isFinal: false, shots: [.two, .seven]), // 9
            Frame(isFinal: false, shots: [.one, .one]), // 2
            Frame(isFinal: false, shots: [.two, .two]), // 4
            Frame(isFinal: false, shots: [.three, .three]), // 6
            Frame(isFinal: true, shots: [.one, .three]) // 4
            ].compactMap({$0})
        XCTAssertEqual(initialFrames.count, 10)

        guard let sut = FrameCollection(frames: initialFrames) else {
            XCTFail("Couldn't prepare test data")
            return
        }

        XCTAssertEqual(sut.runningTotalScore(), 13+3+7+9+7+9+2+4+6+4)
    }

    func testRunningTotalScore_WithOnlyFiveFramesComplete_ReturnsScore() {
        let initialFrames = [
            Frame(isFinal: false, shots: [.strike]), // 13
            Frame(isFinal: false, shots: [.one, .two]), // 3
            Frame(isFinal: false, shots: [.three, .spare(pinsKnockedDown: .seven)]), // 15
            Frame(isFinal: false, shots: [.five, .four]), // 9
            Frame(isFinal: false, shots: [.six, .one]), // 7
            Frame(isFinal: false, shots: []),
            Frame(isFinal: false, shots: []),
            Frame(isFinal: false, shots: []),
            Frame(isFinal: false, shots: []),
            Frame(isFinal: true, shots: [])
            ].compactMap({$0})
        XCTAssertEqual(initialFrames.count, 10)

        guard let sut = FrameCollection(frames: initialFrames) else {
            XCTFail("Couldn't prepare test data")
            return
        }

        XCTAssertEqual(sut.runningTotalScore(), 13+3+15+9+7)
    }

    // MARK: - Test running total score after shot taken mid way through

    func testRunningTotalScore_UpdatesCorrectly_AfterShotIsTaken_InFirstFrame() {
        guard let sut = FrameCollection() else {
            XCTFail("Couldn't prepare test data")
            return
        }

        XCTAssertEqual(sut.runningTotalScore(), 0)

        XCTAssertNoThrow(try sut.take(shot: .one))

        XCTAssertEqual(sut.runningTotalScore(), 1)
    }

    func testRunningTotalScore_UpdatesCorrectly_AfterShotIsTaken_InSecondFrame() {
        guard let sut = FrameCollection() else {
            XCTFail("Couldn't prepare test data")
            return
        }

        XCTAssertEqual(sut.runningTotalScore(), 0)

        XCTAssertNoThrow(try sut.take(shot: .one))
        XCTAssertEqual(sut.runningTotalScore(), 1)

        XCTAssertNoThrow(try sut.take(shot: .five))
        XCTAssertEqual(sut.runningTotalScore(), 6)

        XCTAssertNoThrow(try sut.take(shot: .strike))
        XCTAssertEqual(sut.runningTotalScore(), 16)
    }

    func testRunningTotalScore_UpdatesCorrectly_AfterShotIsTaken_InFifthFrame() {
        guard let sut = FrameCollection() else {
            XCTFail("Couldn't prepare test data")
            return
        }

        XCTAssertEqual(sut.runningTotalScore(), 0)

        // Frame 1

        XCTAssertNoThrow(try sut.take(shot: .one))
        XCTAssertEqual(sut.runningTotalScore(), 1)

        XCTAssertNoThrow(try sut.take(shot: .five))
        XCTAssertEqual(sut.runningTotalScore(), 6)

        // Frame 2

        XCTAssertNoThrow(try sut.take(shot: .strike))
        XCTAssertEqual(sut.runningTotalScore(), 16)

        // Frame 3

        XCTAssertNoThrow(try sut.take(shot: .strike)) // 1+5+10+10
        XCTAssertEqual(sut.runningTotalScore(), 36)

        // Frame 4

        XCTAssertNoThrow(try sut.take(shot: .strike)) // 6 + 30 + 20 + 10
        XCTAssertEqual(sut.runningTotalScore(), 66)

        // Frame 5

        XCTAssertNoThrow(try sut.take(shot: .one)) // 6 + 30 + 21 + 11 + 1
        XCTAssertEqual(sut.runningTotalScore(), 69)

        XCTAssertNoThrow(try sut.take(shot: .three)) // 6 + 30 + 21 + 14 + 4
        XCTAssertEqual(sut.runningTotalScore(), 75)
    }

    func testRunningTotalScore_UpdatesCorrectly_AfterShotIsTaken_InNinthFrame() {
        guard let sut = FrameCollection() else {
            XCTFail("Couldn't prepare test data")
            return
        }

        XCTAssertEqual(sut.runningTotalScore(), 0)

        // Frame 1 (1+5)

        XCTAssertNoThrow(try sut.take(shot: .one))
        XCTAssertEqual(sut.runningTotalScore(), 1)

        XCTAssertNoThrow(try sut.take(shot: .five))
        XCTAssertEqual(sut.runningTotalScore(), 6)

        // Frame 2 (10+10+10)

        XCTAssertNoThrow(try sut.take(shot: .strike))
        XCTAssertEqual(sut.runningTotalScore(), 16)

        // Frame 3 (10+10+1)

        XCTAssertNoThrow(try sut.take(shot: .strike)) // 1+5+10+10
        XCTAssertEqual(sut.runningTotalScore(), 36)

        // Frame 4 (10+1+3)

        XCTAssertNoThrow(try sut.take(shot: .strike)) // 6 + 30 + 20 + 10
        XCTAssertEqual(sut.runningTotalScore(), 66)

        // Frame 5 (4)

        XCTAssertNoThrow(try sut.take(shot: .one)) // 6 + 30 + 21 + 11 + 1
        XCTAssertEqual(sut.runningTotalScore(), 69)

        XCTAssertNoThrow(try sut.take(shot: .three)) // 6 + 30 + 21 + 14 + 4
        XCTAssertEqual(sut.runningTotalScore(), 75)

        // Frame 6 (10+9)

        XCTAssertNoThrow(try sut.take(shot: .four)) // 6 + 30 + 21 + 14 + 4 + 4
        XCTAssertEqual(sut.runningTotalScore(), 79)

        XCTAssertNoThrow(try sut.take(shot: .spare(pinsKnockedDown: .six))) // 6 + 30 + 21 + 14 + 4 + 10
        XCTAssertEqual(sut.runningTotalScore(), 85)

        // Frame 7 (9)

        XCTAssertNoThrow(try sut.take(shot: .nine)) // 6 + 30 + 21 + 14 + 4 + 19 + 9
        XCTAssertEqual(sut.runningTotalScore(), 103)

        XCTAssertNoThrow(try sut.take(shot: .none)) // 6 + 30 + 21 + 14 + 4 + 19 + 9
        XCTAssertEqual(sut.runningTotalScore(), 103)

        // Frame 8 (6)

        XCTAssertNoThrow(try sut.take(shot: .none)) // 6 + 30 + 21 + 14 + 4 + 19 + 9
        XCTAssertEqual(sut.runningTotalScore(), 103)

        XCTAssertNoThrow(try sut.take(shot: .six)) // 6 + 30 + 21 + 14 + 4 + 19 + 9 + 6
        XCTAssertEqual(sut.runningTotalScore(), 109)

        // Frame 9 (8)

        XCTAssertNoThrow(try sut.take(shot: .eight)) // 6 + 30 + 21 + 14 + 4 + 19 + 9 + 6 + 8
        XCTAssertEqual(sut.runningTotalScore(), 117)
    }

    func testRunningTotalScore_UpdatesCorrectly_AfterShotIsTaken_InFinalFrame() {
        let initialFrames = [
            Frame(isFinal: false, shots: [.one, .five]),
            Frame(isFinal: false, shots: [.strike]),
            Frame(isFinal: false, shots: [.strike]),
            Frame(isFinal: false, shots: [.strike]),
            Frame(isFinal: false, shots: [.one, .three]),
            Frame(isFinal: false, shots: [.four, .spare(pinsKnockedDown: .six)]),
            Frame(isFinal: false, shots: [.nine, .none]),
            Frame(isFinal: false, shots: [.none, .six]),
            Frame(isFinal: false, shots: [.eight]),
            Frame(isFinal: true, shots: [])
            ].compactMap({$0})
        XCTAssertEqual(initialFrames.count, 10)

        guard let sut = FrameCollection(frames: initialFrames) else {
            XCTFail("Couldn't prepare test data")
            return
        }

        XCTAssertEqual(sut.runningTotalScore(), 117)

        XCTAssertNoThrow(try sut.take(shot: .one))
        XCTAssertEqual(sut.runningTotalScore(), 118)

        // Frame 10

        XCTAssertNoThrow(try sut.take(shot: .one))
        XCTAssertEqual(sut.runningTotalScore(), 119)

        XCTAssertNoThrow(try sut.take(shot: .spare(pinsKnockedDown: .nine)))
        XCTAssertEqual(sut.runningTotalScore(), 128)

        XCTAssertNoThrow(try sut.take(shot: .strike))
        XCTAssertEqual(sut.runningTotalScore(), 138)
    }
}
