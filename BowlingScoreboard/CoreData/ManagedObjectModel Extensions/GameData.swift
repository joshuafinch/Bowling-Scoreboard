//
//  GameData.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 03/09/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation
import CoreData

extension GameData {

    private enum CodingError: Error {
        case decoding(String)
        case encoding
    }

    static func fetchRequest(identifier: UUID) -> NSFetchRequest<GameData> {
        let request: NSFetchRequest<GameData> = GameData.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", "identifier", identifier as CVarArg)
        return request
    }

    static func updateOrCreateGame(game: Game, context: NSManagedObjectContext) throws {
        guard let encoded = try? PropertyListEncoder().encode(game.players) else {
            throw CodingError.encoding
        }

        let fetchRequest = GameData.fetchRequest(identifier: game.identifier)
        let results = try context.fetch(fetchRequest)
        let result = results.first ?? GameData(context: context)
        result.identifier = game.identifier
        result.playersFrames = encoded
        result.startDate = game.startDate
    }
}
