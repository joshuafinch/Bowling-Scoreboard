//
//  WelcomeCoordinator.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 02/09/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation
import UIKit

final class WelcomeCoordinator {

    typealias EnterNicknameViewFactory = EnterTextViewFactory<String, NicknameValidationError>
    private var enterNicknameViewModel: EnterNicknameViewFactory.ViewModel?

    private let profileController: ProfileController

    init(profileController: ProfileController) {
        self.profileController = profileController
    }

    // MARK: -

    func createWelcomeFlow(onFinished finished: @escaping () -> Void) -> UIViewController {

        let finishedEnteringNickname: EnterNicknameViewFactory.ResultCallback = { [unowned self] entry in
            let details = UserProfileDetails(nickname: entry)
            self.profileController.save(userProfileDetails: details)
            finished()
        }

        let enterNicknameValidator: EnterNicknameViewFactory.Validator = { entry in
            guard let entry = entry else {
                return .invalid(.isMandatory)
            }

            let trimmed = entry.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

            if trimmed.isEmpty {
                return .invalid(.onlyWhitespaceCharactersPresent)
            }

            return .valid(trimmed)
        }

        let enterNicknameState = EnterNicknameViewFactory.State(labelText: "What's your nickname?",
                                                                initialTextFieldText: nil,
                                                                placeholderTextFieldText: nil,
                                                                textContentType: .nickname)

        let (enterNicknameViewModel, enterNicknameViewController) = EnterNicknameViewFactory.create(
            state: enterNicknameState, validator: enterNicknameValidator, resultCallback: finishedEnteringNickname
        )

        self.enterNicknameViewModel = enterNicknameViewModel

        return enterNicknameViewController
    }
}
