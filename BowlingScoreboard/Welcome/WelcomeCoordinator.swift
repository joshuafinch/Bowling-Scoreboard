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

            let trimmed = entry.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

            if trimmed.isEmpty {
                return .invalid(.onlyWhitespaceCharactersPresent)
            }

            return .valid(trimmed)
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
