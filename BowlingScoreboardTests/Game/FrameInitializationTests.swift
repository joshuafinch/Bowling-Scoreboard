//
//  FrameInitializationTests.swift
//  BowlingScoreboardTests
//
//  Created by Joshua Finch on 01/09/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation
import XCTest
@testable import BowlingScoreboard

final class FrameInitializationTests: XCTestCase {

    func testInitAnEmptyFrame_ReturnsNotNil() {
        let frame = Frame()
        XCTAssertNotNil(frame)
    }

    func testInitGutterballFirstShotNonFinalFrame_ReturnsNotNil() {
        let frame = Frame(isFinal: false, shots: [.none])
        XCTAssertNotNil(frame)
    }

    func testInitGutterballFirstShotValidSecondShotNonFinalFrame_ReturnsNotNil() {
        let frame = Frame(isFinal: false, shots: [.none, .eight])
        XCTAssertNotNil(frame)
    }

    func testInitGutterballFirstShotSpareSecondShotNonFinalFrame_ReturnsNotNil() {
        let frame = Frame(isFinal: false, shots: [.none, .spare(pinsKnockedDown: .ten)])
        XCTAssertNotNil(frame)
    }

    func testInitGutterballFirstShotInvalidSpareSecondShotNonFinalFrame_ReturnsNil() {
        let frame = Frame(isFinal: false, shots: [.none, .spare(pinsKnockedDown: .seven)])
        XCTAssertNil(frame)
    }

    func testInitGutterballSecondShotNonFinalFrame_ReturnsNotNil() {
        let frame = Frame(isFinal: false, shots: [.four, .none])
        XCTAssertNotNil(frame)
    }

    func testInitInvalidInitialSpareShotNonFinalFrame_ReturnsNil() {
        let frame = Frame(isFinal: false, shots: [.spare(pinsKnockedDown: .ten)])
        XCTAssertNil(frame)
    }

    func testInitValidSpareShotNonFinalFrame_ReturnsNotNil() {
        let frame = Frame(isFinal: false, shots: [.three, .spare(pinsKnockedDown: .seven)])
        XCTAssertNotNil(frame)
    }

    func testInitInvalidSpareShotNonFinalFrame_ReturnsNil() {
        let frame = Frame(isFinal: false, shots: [.three, .spare(pinsKnockedDown: .nine)])
        XCTAssertNil(frame)
    }

    func testInitInvalidSpareShotFinalFrame_ReturnsNil() {
        let frame = Frame(isFinal: true, shots: [.strike, .strike, .spare(pinsKnockedDown: .ten)])
        XCTAssertNil(frame)
    }

    func testInitInvalidSpareShot_2_FinalFrame_ReturnsNil() {
        let frame = Frame(isFinal: true, shots: [.strike, .strike, .spare(pinsKnockedDown: .one)])
        XCTAssertNil(frame)
    }

    func testInitThreeStrikes_FinalFrame_ReturnsNotNil() {
        let frame = Frame(isFinal: true, shots: [.strike, .strike, .strike])
        XCTAssertNotNil(frame)
    }

    func testInitThreeStrikes_NonFinalFrame_ReturnsNil() {
        let frame = Frame(isFinal: false, shots: [.strike, .strike, .strike])
        XCTAssertNil(frame)
    }

    func testInitThreeShots_NonFinalFrame_ReturnsNil() {
        let frame = Frame(isFinal: false, shots: [.one, .two, .four])
        XCTAssertNil(frame)
    }

    func testInitThreeShots_NoStrike_FinalFrame_ReturnsNil() {
        let frame = Frame(isFinal: true, shots: [.one, .two, .four])
        XCTAssertNil(frame)
    }

    func testInitThreeShots_WithSpare_FinalFrame_ReturnsNotNil() {
        let frame = Frame(isFinal: true, shots: [.one, .spare(pinsKnockedDown: .nine), .four])
        XCTAssertNotNil(frame)
    }

    func testInitSecondShot_AfterStrike_NonFinalFrame_ReturnsNil() {
        let frame = Frame(isFinal: false, shots: [.strike, .four])
        XCTAssertNil(frame)
    }

    func testInitStrikeSecondShot_NonFinalFrame_ReturnsNil() {
        let frame = Frame(isFinal: false, shots: [.one, .strike])
        XCTAssertNil(frame)
    }

    func testInitSpareAfterStrike_FinalFrame_ReturnsNil() {
        let frame = Frame(isFinal: true, shots: [.strike, .spare(pinsKnockedDown: .one)])
        XCTAssertNil(frame)
    }

    func testInitSpareAfterStrikeWithThirdShot_FinalFrame_ReturnsNil() {
        let frame = Frame(isFinal: true, shots: [.strike, .spare(pinsKnockedDown: .one), .nine])
        XCTAssertNil(frame)
    }

    func testInitSpareThirdShot_FinalFrame_ReturnsNotNil() {
        let frame = Frame(isFinal: true, shots: [.strike, .nine, .spare(pinsKnockedDown: .one)])
        XCTAssertNotNil(frame)
    }

    func testInitStrikeSecondShot_FinalFrame_ReturnsNotNil() {
        let frame = Frame(isFinal: true, shots: [.strike, .strike])
        XCTAssertNotNil(frame)
    }

    func testInitSecondShotKnocksDownFinalPin_ButNotDeclaredAsSpare_ReturnsNil() {
        let frame = Frame(isFinal: false, shots: [.five, .five])
        XCTAssertNil(frame)
    }

    func testInitSecondShotKnocksDownFinalPin_ButNotDeclaredAsSpare_FinalFrame_ReturnsNil() {
        let frame = Frame(isFinal: true, shots: [.five, .five])
        XCTAssertNil(frame)
    }

    func testInitThirdShotKnocksDownFinalPin_ButNotDeclaredAsSpare_FinalFrame_ReturnsNil() {
        let frame = Frame(isFinal: true, shots: [.strike, .one, .nine])
        XCTAssertNil(frame)
    }

    func testInitSecondShotKnocksDownTooManyPins_ReturnsNil() {
        let frame = Frame(isFinal: false, shots: [.five, .six])
        XCTAssertNil(frame)
    }

    func testInitSecondShotKnocksDownTooManyPins_FinalFrame_ReturnsNil() {
        let frame = Frame(isFinal: true, shots: [.five, .six])
        XCTAssertNil(frame)
    }

    func testInitThirdShotKnocksDownTooManyPins_FinalFrame_ReturnsNil() {
        let frame = Frame(isFinal: true, shots: [.strike, .five, .six])
        XCTAssertNil(frame)
    }
}
