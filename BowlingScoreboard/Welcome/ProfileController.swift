//
//  ProfileController.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 03/09/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation
import CoreData

class ProfileController {

    private let dataController: CoreDataController

    init(dataController: CoreDataController) {
        self.dataController = dataController
    }

    func save(userProfileDetails details: UserProfileDetails) {
        dataController.performBackgroundTask { (context) in
            do {
                try UserProfile.updateOrCreateUserProfile(details: details, context: context)

                if context.hasChanges {
                    do {
                        try context.save()
                    } catch {
                        // Can fail if the device storage is full (and a number of other unavoiable reasons)
                        // We should handle this better than creating a stack trace
                        fatalError("Couldn't save changes after updating user profile: \(error)")
                    }
                }
            } catch {
                fatalError("Couldn't update user profile: \(error)")
            }
        }
    }
}
