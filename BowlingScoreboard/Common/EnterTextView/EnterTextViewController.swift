//
//  EnterTextViewController.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 02/09/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation
import UIKit

final class EnterTextViewController: UIViewController {

    var viewModel: EnterTextViewModelType!

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    // MARK: -

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: Notification.Name.UIKeyboardWillShow,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidShow),
                                               name: Notification.Name.UIKeyboardDidShow,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: Notification.Name.UIKeyboardWillHide,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidHide),
                                               name: Notification.Name.UIKeyboardDidHide,
                                               object: nil)

        viewModel.label = label
        viewModel.textField = textField

        navigationItem.largeTitleDisplayMode = .never
    }

    // MARK: - Keyboard

    @objc func keyboardWillHide(notification: Notification) {
        handleKeyboard(notification: notification)
    }

    @objc func keyboardDidHide(notification: Notification) {

    }

    @objc func keyboardWillShow(notification: Notification) {
        handleKeyboard(notification: notification)
    }

    @objc func keyboardDidShow(notification: Notification) {

    }

    private func handleKeyboard(notification: Notification) {
        guard let bottomConstraint = bottomConstraint else {
            return
        }

        guard let info = notification.userInfo else {
            return
        }

        guard let endFrame = info[UIKeyboardFrameEndUserInfoKey] as? CGRect,
            let beginFrame = info[UIKeyboardFrameBeginUserInfoKey] as? CGRect,
            let duration = info[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let curve = info[UIKeyboardAnimationCurveUserInfoKey] as? Int else {
                return
        }

        let keyboardPadding: CGFloat = 16.0

        let previousKeyboardHeight = bottomConstraint.constant - keyboardPadding

        let keyboardRect = view.convert(endFrame, from: nil)
        let viewHeight = view.bounds.height
        let keyboardMinY = keyboardRect.minY
        let keyboardHeight = max(0.0, viewHeight - keyboardMinY)

        if beginFrame != endFrame || fabs(previousKeyboardHeight - keyboardHeight) > 0.0 {
            view.layoutIfNeeded()

            bottomConstraint.constant = keyboardHeight + keyboardPadding

            let options = UIViewAnimationOptions(rawValue: UInt(curve << 16)).union([.beginFromCurrentState, .layoutSubviews])
            UIView.animate(withDuration: duration, delay: 0.0, options: options, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
}
