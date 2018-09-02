//
//  GameCellViewModel.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 03/09/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation

struct GameCellViewModel {

    let date: String

    init?(gameData: GameData) {
        guard let startDate = gameData.startDate else {
            return nil
        }

        self.date = DateFormatter.localizedString(from: startDate, dateStyle: .short, timeStyle: .short)
    }
}
