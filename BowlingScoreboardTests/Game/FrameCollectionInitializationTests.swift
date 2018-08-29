//
//  FrameCollectionInitializationTests.swift
//  BowlingScoreboardTests
//
//  Created by Joshua Finch on 01/09/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation
import XCTest
@testable import BowlingScoreboard

final class FrameCollectionInitializationTests: XCTestCase {

    func testInit_WithoutFrames_ReturnsNil() {
        XCTAssertNil(FrameCollection(frames: []))
    }

    func testInit_WithLessThan10Frames_ReturnsNil() {
        XCTAssertNil(FrameCollection(frames: [Frame()].compactMap({$0})))
    }

    func testInit_WithGreaterThan10Frames_ReturnsNil() {
        let frames = [Frame(),
                      Frame(),
                      Frame(),
                      Frame(),
                      Frame(),
                      Frame(),
                      Frame(),
                      Frame(),
                      Frame(),
                      Frame(isFinal: true),
                      Frame()]
            .compactMap({$0})
        XCTAssertNil(FrameCollection(frames: frames))
    }

    func testInit_WithFinalFrameNotMarkedAsFinal_ReturnsNil() {
        let frames = [Frame(),
                      Frame(),
                      Frame(),
                      Frame(),
                      Frame(),
                      Frame(),
                      Frame(),
                      Frame(),
                      Frame(),
                      Frame()]
            .compactMap({$0})
        XCTAssertNil(FrameCollection(frames: frames))
    }

    func testInit_WithNonFinalFrameMarkedAsFinal_ReturnsNil() {
        let frames = [Frame(),
                      Frame(isFinal: true),
                      Frame(),
                      Frame(),
                      Frame(),
                      Frame(),
                      Frame(),
                      Frame(),
                      Frame(),
                      Frame(isFinal: true)]
            .compactMap({$0})
        XCTAssertNil(FrameCollection(frames: frames))
    }

    func testInit_WithTenFramesNoShots_ReturnsNotNil() {
        let frames = [
            Frame(),
            Frame(),
            Frame(),
            Frame(),
            Frame(),
            Frame(),
            Frame(),
            Frame(),
            Frame(),
            Frame(isFinal: true)
            ].compactMap({$0})
        XCTAssertEqual(frames.count, 10)
        XCTAssertNotNil(FrameCollection(frames: frames))
    }

    func testInit_WithTenFramesPlayed_ReturnsNotNil() {
        let frames = [
            Frame(isFinal: false, shots: [.strike]),
            Frame(isFinal: false, shots: [.one, .spare(pinsKnockedDown: .nine)]),
            Frame(isFinal: false, shots: [.two, .spare(pinsKnockedDown: .eight)]),
            Frame(isFinal: false, shots: [.three, .spare(pinsKnockedDown: .seven)]),
            Frame(isFinal: false, shots: [.four, .spare(pinsKnockedDown: .six)]),
            Frame(isFinal: false, shots: [.five, .spare(pinsKnockedDown: .five)]),
            Frame(isFinal: false, shots: [.six, .spare(pinsKnockedDown: .four)]),
            Frame(isFinal: false, shots: [.seven, .spare(pinsKnockedDown: .three)]),
            Frame(isFinal: false, shots: [.eight, .spare(pinsKnockedDown: .two)]),
            Frame(isFinal: true, shots: [.nine, .spare(pinsKnockedDown: .one), .strike])
            ].compactMap({$0})
        XCTAssertEqual(frames.count, 10)
        XCTAssertNotNil(FrameCollection(frames: frames))
    }
}
