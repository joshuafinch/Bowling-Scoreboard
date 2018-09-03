//
//  NicknameValidationError.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 03/09/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation

enum NicknameValidationError: Error {
    case isMandatory
    case onlyWhitespaceCharactersPresent
}
