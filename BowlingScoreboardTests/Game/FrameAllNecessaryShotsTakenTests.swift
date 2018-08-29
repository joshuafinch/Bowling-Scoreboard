//
//  FrameAllNecessaryShotsTakenTests.swift
//  BowlingScoreboardTests
//
//  Created by Joshua Finch on 29/08/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation
import XCTest
@testable import BowlingScoreboard

final class FrameAllNecessaryShotsTakenTests: XCTestCase {

    func testAllNecessaryShotsTaken_WithAnEmpty_NonFinalFrame_ReturnsFalse() {
        guard let frame = Frame() else {
            XCTFail("Unable to create test data")
            return
        }
        XCTAssertFalse(frame.allNecessaryShotsTaken())
    }

    func testAllNecessaryShotsTaken_WithAnEmpty_FinalFrame_ReturnsFalse() {
        guard let frame = Frame(isFinal: true, shots: []) else {
            XCTFail("Unable to create test data")
            return
        }
        XCTAssertFalse(frame.allNecessaryShotsTaken())
    }

    func testAllNecessaryShotsTaken_WithSingleShot_NonFinalFrame_ReturnsFalse() {
        guard let frame = Frame(isFinal: false, shots: [.one]) else {
            XCTFail("Unable to create test data")
            return
        }
        XCTAssertFalse(frame.allNecessaryShotsTaken())
    }

    func testAllNecessaryShotsTaken_WithTwoShots_NonFinalFrame_ReturnsTrue() {
        guard let frame = Frame(isFinal: false, shots: [.one, .three]) else {
            XCTFail("Unable to create test data")
            return
        }
        XCTAssertTrue(frame.allNecessaryShotsTaken())
    }

    func testAllNecessaryShotsTaken_WithTwoShots_FinalFrame_ReturnsTrue() {
        guard let frame = Frame(isFinal: true, shots: [.one, .three]) else {
            XCTFail("Unable to create test data")
            return
        }
        XCTAssertTrue(frame.allNecessaryShotsTaken())
    }

    func testAllNecessaryShotsTaken_WithOneShot_FinalFrame_ReturnsFalse() {
        guard let frame = Frame(isFinal: true, shots: [.one]) else {
            XCTFail("Unable to create test data")
            return
        }
        XCTAssertFalse(frame.allNecessaryShotsTaken())
    }

    func testAllNecessaryShotsTaken_WithOneMiss_FinalFrame_ReturnsFalse() {
        guard let frame = Frame(isFinal: true, shots: [.none]) else {
            XCTFail("Unable to create test data")
            return
        }
        XCTAssertFalse(frame.allNecessaryShotsTaken())
    }

    func testAllNecessaryShotsTaken_WithStrike_NonFinalFrame_ReturnsTrue() {
        guard let frame = Frame(isFinal: false, shots: [.strike]) else {
            XCTFail("Unable to create test data")
            return
        }
        XCTAssertTrue(frame.allNecessaryShotsTaken())
    }

    func testAllNecessaryShotsTaken_WithThirdShot_InFinalFrame_ReturnsTrue() {
        guard let frame = Frame(isFinal: true, shots: [.strike, .three, .spare(pinsKnockedDown: .seven)]) else {
            XCTFail("Unable to create test data")
            return
        }
        XCTAssertTrue(frame.allNecessaryShotsTaken())
    }

    func testAllNecessaryShotsTaken_WithOneStrike_InFinalFrame_ReturnsFalse() {
        guard let frame = Frame(isFinal: true, shots: [.strike]) else {
            XCTFail("Unable to create test data")
            return
        }
        XCTAssertFalse(frame.allNecessaryShotsTaken())
    }

    func testAllNecessaryShotsTaken_WithSpareOneShotRemaining_InFinalFrame_ReturnsFalse() {
        guard let frame = Frame(isFinal: true, shots: [.one, .spare(pinsKnockedDown: .nine)]) else {
            XCTFail("Unable to create test data")
            return
        }
        XCTAssertFalse(frame.allNecessaryShotsTaken())
    }

    func testAllNecessaryShotsTaken_WithSecondStrikeOneShotRemaining_InFinalFrame_ReturnsFalse() {
        guard let frame = Frame(isFinal: true, shots: [.strike, .strike]) else {
            XCTFail("Unable to create test data")
            return
        }
        XCTAssertFalse(frame.allNecessaryShotsTaken())
    }
}
