//
//  EnterTextViewModel.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 02/09/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation
import UIKit

final class EnterTextViewModel<Result, ValidationError>: NSObject, EnterTextViewModelType, UITextFieldDelegate {

    // MARK: - Nested Types

    enum Validation<Result> {
        case valid(Result)
        case invalid(ValidationError)
    }

    typealias Validator = (_ entry: String?) -> Validation<Result>
    typealias ResultCallback = (_ result: Result) -> Void

    struct State {
        let labelText: String?
        let initialTextFieldText: String?
        let placeholderTextFieldText: String?
        let textContentType: UITextContentType?
    }

    // MARK: - Properties

    weak var label: UILabel! {
        didSet {
            updateLabel()
        }
    }

    weak var textField: UITextField! {
        didSet {
            updateTextField()
        }
    }

    private var state: State {
        didSet {
            updateLabel()
            updateTextField()
        }
    }

    private let resultCallback: ResultCallback
    private let validator: Validator

    // MARK: - Initialization

    init(state: State, validator: @escaping Validator, resultCallback: @escaping ResultCallback) {
        self.state = state
        self.validator = validator
        self.resultCallback = resultCallback

        super.init()

        updateLabel()
        updateTextField()
    }

    // MARK: - Private

    private func updateLabel() {
        label?.text = state.labelText
    }

    private func updateTextField() {
        textField?.textContentType = state.textContentType
        textField?.placeholder = state.placeholderTextFieldText
        textField?.text = state.initialTextFieldText
        textField?.delegate = self
        textField?.becomeFirstResponder()
    }

    // MARK: - UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if case .valid(let result) = validator(textField.text) {
            textField.resignFirstResponder()
            resultCallback(result)
            return true
        }
        return false
    }
}
