//
//  UserProfile.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 03/09/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation
import CoreData

extension UserProfile {

    static func updateOrCreateUserProfile(details: UserProfileDetails, context: NSManagedObjectContext) throws {
        let results = try context.fetch(UserProfile.fetchRequest())
        let result = results.first as? UserProfile ?? UserProfile(context: context)
        result.nickname = details.nickname
    }

    static func exists(context: NSManagedObjectContext) -> Bool {
        do {
            let results = try context.fetch(UserProfile.fetchRequest())
            return !results.isEmpty
        } catch {
            fatalError("Couldn't fetch user profile")
        }
    }

    static func currentPlayerName(context: NSManagedObjectContext) -> String? {
        do {

            let results = try context.fetch(UserProfile.fetchRequest()) as [UserProfile]
            return results.first?.nickname
        } catch {
            fatalError("Couldn't fetch user profile")
        }
    }
}
