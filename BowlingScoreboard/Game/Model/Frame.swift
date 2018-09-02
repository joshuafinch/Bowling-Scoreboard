//
//  Frame.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 29/08/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation
import os

struct Frame: Equatable {

    // MARK: - Properties

    /// Denotes whether this is the final (tenth) frame
    let isFinal: Bool

    /// Current shot scores in this frame
    let shots: [Shot]

    private let maxPins = 10

    // MARK: - Initialization

    init?(isFinal: Bool = false, shots: [Shot] = []) {
        self.isFinal = isFinal
        self.shots = shots

        do {
            try validate()
        } catch {
            return nil
        }
    }

    // MARK: - Public Functions

    func allNecessaryShotsTaken() -> Bool {
        if isFinal {
            return allNecessaryShotsTakenInFinalFrame()
        }

        return allNecessaryShotsTakenInNonFinalFrame()
    }

    func take(shot: Shot) throws -> Frame {
        if allNecessaryShotsTaken() {
            throw TakeShotError.alreadyTakenNecessaryShotsInThisFrame
        }

        var newShots = shots
        newShots.append(shot)

        guard let newFrame = Frame(isFinal: isFinal, shots: newShots) else {
            throw TakeShotError.invalidShot
        }

        return newFrame
    }

    func availableShots() -> [Shot] {
        if allNecessaryShotsTaken() {
            return []
        }

        let allShots: [Shot] = [.none,
                                .one,
                                .two,
                                .three,
                                .four,
                                .five,
                                .six,
                                .seven,
                                .eight,
                                .nine,
                                .spare(pinsKnockedDown: .one),
                                .spare(pinsKnockedDown: .two),
                                .spare(pinsKnockedDown: .three),
                                .spare(pinsKnockedDown: .four),
                                .spare(pinsKnockedDown: .five),
                                .spare(pinsKnockedDown: .six),
                                .spare(pinsKnockedDown: .seven),
                                .spare(pinsKnockedDown: .eight),
                                .spare(pinsKnockedDown: .nine),
                                .spare(pinsKnockedDown: .ten),
                                .strike]

        return allShots.filter({ (try? take(shot: $0)) != nil })
    }

    // MARK: - Private

    private func validate() throws {
        if shots.isEmpty {
            return
        }

        if (!isFinal && shots.count > 2) || shots.count > 3 {
            throw ScoreCalculationError.tooManyShotsInSingleFrame
        }

        if case .spare = shots[0] {
            // Not possible to get a spare on your first shot
            throw ScoreCalculationError.spareOnFirstShot
        }

        if shots.count == 1 {
            // No other validation required for a single shot in a frame
            return
        }

        // Checks for second and third shots

        if case .strike = shots[0] {
            if !isFinal {
                // Cannot have a second or third shot after a strike in the non-final frame
                throw ScoreCalculationError.tooManyShotsInSingleFrame
            }
        }

        if shots.count == 2 && !isFinal {
            try validateSecondShotIsPossibleInNonFinalFrame()
        }

        if shots.count == 2 && isFinal {
            try validateSecondShotIsPossibleInFinalFrame()
        }

        if shots.count == 3 {
            try validateThirdShotIsPossibleInFinalFrame()
        }
    }

    private func allNecessaryShotsTakenInNonFinalFrame() -> Bool {

        if shots.isEmpty {
            return false
        }

        if case .strike = shots[0] {
            return true
        }

        if shots.count >= 2 {
            return true
        }

        return false
    }

    private func allNecessaryShotsTakenInFinalFrame() -> Bool {

        if shots.count >= 3 {
            return true
        }

        if shots.count < 2 {
            return false
        }

        if case .strike = shots[0] {
            return false
        }

        if shots.count >= 2 {
            if case .spare = shots[1] {
                return false
            }
        }

        return true
    }

    private func validateSecondShotIsPossibleInNonFinalFrame() throws {
        if case .strike = shots[1] {
            // Cannot have a strike on the second shot in a non-final frame
            throw ScoreCalculationError.strikeOnSecondShotInNonFinalFrame
        } else if case .spare(let pinsKnockedDown) = shots[1] {
            try validateSpare(pinsKnockedDown: pinsKnockedDown, previousShot: shots[0])
        } else if shots[0].numericValue + shots[1].numericValue == 10 {
            throw ScoreCalculationError.secondShotShouldHaveBeenSpare
        } else if shots[0].numericValue + shots[1].numericValue > 10 {
            throw ScoreCalculationError.knockedDownMorePinsThanAvailable
        }
    }

    private func validateSecondShotIsPossibleInFinalFrame() throws {
        if case .spare(let pinsKnockedDown) = shots[1] {
            try validateSpare(pinsKnockedDown: pinsKnockedDown, previousShot: shots[0])
        } else if case .strike = shots[0] {
            // just using this to get an else here
        } else if shots[0].numericValue + shots[1].numericValue == 10 {
            throw ScoreCalculationError.secondShotShouldHaveBeenSpare
        } else if shots[0].numericValue + shots[1].numericValue > 10 {
            throw ScoreCalculationError.knockedDownMorePinsThanAvailable
        }
    }

    private func validateSpare(pinsKnockedDown: PinsKnockedDown, previousShot: Shot) throws {

        if case .spare = previousShot {
            throw ScoreCalculationError.spareAfterSpare
        }

        if previousShot.numericValue + pinsKnockedDown.rawValue > maxPins {
            // Cannot knock down more pins than are available
            throw ScoreCalculationError.spareKnockedDownMorePinsThanAvailable
        }

        if maxPins - pinsKnockedDown.rawValue != previousShot.numericValue {
            throw ScoreCalculationError.spareDidNotKnockDownRemainingPins
        }
    }

    /// Can only have three shots in the final frame if the first shot was a strike
    /// or the second shot was a spare/strike
    private func validateThirdShotIsPossibleInFinalFrame() throws {

        if case .spare(let pinsKnockedDown) = shots[1] {
            try validateSpare(pinsKnockedDown: pinsKnockedDown, previousShot: shots[0])
        } else if case .strike = shots[1] {
            // just using this to get an else here
        } else if case .spare = shots[2] {
            // just using this to get an else here
        } else if shots[1].numericValue + shots[2].numericValue == 10 {
            throw ScoreCalculationError.thirdShotShouldHaveBeenSpare
        } else if shots[1].numericValue + shots[2].numericValue > 10 {
            throw ScoreCalculationError.knockedDownMorePinsThanAvailable
        }

        if case .spare(let pinsKnockedDown) = shots[2] {
            try validateSpare(pinsKnockedDown: pinsKnockedDown, previousShot: shots[1])
        }

        if case .strike = shots[0] {
            // Strike on first shot, always gets three shots.
            return
        }

        if case .spare = shots[1] {
            // Spare on second shot, gets additional (third shot).
            return
        }

        throw ScoreCalculationError.tooManyShotsInSingleFrame
    }
}
