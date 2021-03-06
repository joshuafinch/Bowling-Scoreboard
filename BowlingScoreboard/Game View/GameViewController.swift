//
//  GameViewController.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 01/09/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import UIKit

final class GameViewController: UIViewController {

    var viewModel: GameViewModel?

    @IBOutlet weak var playerOneLabel: UILabel!
    @IBOutlet weak var playerTwoLabel: UILabel!
    @IBOutlet weak var turnToShootMessage: UILabel!
    @IBOutlet weak var framesCollectionViewHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.framesCollectionViewHeightConstraint = framesCollectionViewHeightConstraint

        viewModel?.playerOneLabel = playerOneLabel
        viewModel?.playerTwoLabel = playerTwoLabel
        viewModel?.turnToShootMessage = turnToShootMessage

        navigationItem.largeTitleDisplayMode = .never
    }

    override func viewWillDisappear(_ animated: Bool) {
        viewModel?.onViewWillDisappear()
        super.viewWillDisappear(animated)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if let framesCollectionViewController = segue.destination as? FramesCollectionViewController {
            viewModel?.framesCollectionViewController = framesCollectionViewController
        }

        if let availableShotsCollectionViewController = segue.destination as? AvailableShotsCollectionViewController {
            viewModel?.availableShotsCollectionViewController = availableShotsCollectionViewController
        }
    }
}
