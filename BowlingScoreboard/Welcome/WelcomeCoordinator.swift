//
//  WelcomeCoordinator.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 02/09/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct UserProfileDetails {
    let nickname: String
}

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
}

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

enum NicknameValidationError: Error {
    case isMandatory
}

final class WelcomeCoordinator {

    typealias EnterNicknameViewModel = EnterTextViewModel<String, NicknameValidationError>
    private var enterNicknameViewModel: EnterNicknameViewModel?

    private let profileController: ProfileController

    init(profileController: ProfileController) {
        self.profileController = profileController
    }

    // MARK: -

    func createWelcomeFlow(onFinished finished: @escaping () -> Void) -> UIViewController {

        let finishedEnteringNickname: EnterNicknameViewModel.ResultCallback = { [unowned self] entry in
            let details = UserProfileDetails(nickname: entry)
            self.profileController.save(userProfileDetails: details)
            finished()
        }

        let enterNicknameValidator: EnterNicknameViewModel.Validator = { entry in
            guard let entry = entry else {
                return .invalid(.isMandatory)
            }

            return .valid(entry)
        }

        let enterNicknameState = EnterNicknameViewModel.State(labelText: "What's your nickname?",
                                                              initialTextFieldText: nil,
                                                              placeholderTextFieldText: nil,
                                                              textContentType: .nickname)

        let (enterNicknameViewModel, enterNicknameViewController) = createEnterTextView(state: enterNicknameState,
                                                                                        validator: enterNicknameValidator,
                                                                                        resultCallback: finishedEnteringNickname)

        self.enterNicknameViewModel = enterNicknameViewModel

        return enterNicknameViewController
    }

    // MARK: - View Factories

    private func createEnterTextView<R, E>(
        state: EnterTextViewModel<R, E>.State,
        validator: @escaping EnterTextViewModel<R, E>.Validator,
        resultCallback: @escaping EnterTextViewModel<R, E>.ResultCallback) -> (EnterTextViewModel<R, E>, EnterTextViewController) {

        let storyboard = UIStoryboard(name: "EnterTextViewController", bundle: .main)

        // swiftlint:disable:next force_cast
        let viewController = storyboard.instantiateInitialViewController() as! EnterTextViewController

        let viewModel = EnterTextViewModel(state: state, validator: validator, resultCallback: resultCallback)
        viewController.viewModel = viewModel

        return (viewModel, viewController)
    }
}
