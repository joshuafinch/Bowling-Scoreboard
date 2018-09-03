//
//  EnterTextViewFactory.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 03/09/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import UIKit

final class EnterTextViewFactory<R, E> {

    typealias ViewModel = EnterTextViewModel<R, E>
    typealias State = ViewModel.State
    typealias Validator = ViewModel.Validator
    typealias ResultCallback = ViewModel.ResultCallback
    typealias ViewController = EnterTextViewController

    static func create(
        state: State,
        validator: @escaping Validator,
        resultCallback: @escaping ResultCallback) -> (ViewModel, ViewController) {

        let storyboard = UIStoryboard(name: "EnterTextViewController", bundle: .main)

        // swiftlint:disable:next force_cast
        let viewController = storyboard.instantiateInitialViewController() as! EnterTextViewController

        let viewModel = ViewModel(state: state, validator: validator, resultCallback: resultCallback)
        viewController.viewModel = viewModel

        return (viewModel, viewController)
    }
}
