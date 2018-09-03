//
//  GameDelegate.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 03/09/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation

protocol GameDelegate: class {

    func currentPlayerDidChange()

    func gameFinished()

    func availableShotsDidChange(toShots: [Shot])

    func framesDidChange(toPlayerFrames: [PlayerFrames])
}
