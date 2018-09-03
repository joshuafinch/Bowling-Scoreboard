//
//  GamesTableViewController.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 02/09/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import UIKit

final class GamesTableViewController: UITableViewController {

    var viewModel: GamesViewModel!

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.tableView = tableView
    }

    // MARK: -

    @IBAction func newGame(_ sender: Any) {
        viewModel.startNewGame()
    }
}
