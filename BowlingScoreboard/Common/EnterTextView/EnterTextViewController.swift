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

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.label = label
        viewModel.textField = textField

        navigationItem.largeTitleDisplayMode = .never
    }
}
