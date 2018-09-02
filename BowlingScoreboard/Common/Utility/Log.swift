//
//  Log.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 30/08/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation
import os

struct Log {
    static let general = OSLog(subsystem: "codes.joshua.bowlingscoreboard", category: "general")
    static let takeShot = OSLog(subsystem: "codes.joshua.bowlingscoreboard", category: "takeShot")
}
