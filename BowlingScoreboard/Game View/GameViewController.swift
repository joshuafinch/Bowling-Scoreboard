//
//  GameViewController.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 01/09/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation
import UIKit
import os

protocol TakeShotDelegate: class {

    func take(shot: Shot)
}

class GameViewModel: GameDelegate, TakeShotDelegate {

    var framesCollectionViewController: FramesCollectionViewController? {
        didSet {
            updateFrames()
        }
    }

    var availableShotsCollectionViewController: AvailableShotsCollectionViewController? {
        didSet {
            availableShotsCollectionViewController?.takeShotDelegate = self
            updateAvailableShots()
        }
    }

    weak var framesCollectionViewHeightConstraint: NSLayoutConstraint? {
        didSet {
            let heightPerPlayer = FramesCollectionViewFlowLayout.Constants.itemSize.height + FramesCollectionViewFlowLayout.Constants.lineSpacing
            framesCollectionViewHeightConstraint?.constant = heightPerPlayer * CGFloat(game.players.count)
        }
    }

    private let game: Game
    private let dataController: CoreDataController

    init(game: Game, dataController: CoreDataController) {
        self.dataController = dataController
        self.game = game
        game.delegate = self
    }

    func onViewWillDisappear() {
        save()
    }

    // MARK: - GameDelegate

    func currentPlayerDidChange() {
        // TODO: Indicate the current player that's taking a shot
    }

    func gameFinished() {
        // TODO: Hide available shots input, show game finished / winner message, some fanfare and an animation
    }

    func availableShotsDidChange(toShots shots: [Shot]) {
        updateAvailableShots(usingAvailableShots: shots)
    }

    func framesDidChange(toPlayerFrames playerFrames: [PlayerFrames]) {
        updateFrames(usingPlayerFrames: playerFrames)
    }

    // MARK: - TakeShotDelegate

    func take(shot: Shot) {
        do {
            try game.take(shot: shot)
            // TODO: If shot was a spare / strike, show some fanfare and an animation
        } catch let error {
            os_log("Failed to take shot (numericValue: %@) due to error: %@",
                   log: Log.takeShot, type: .error,
                   shot.numericValue, error.localizedDescription)
        }
    }

    // MARK: - Private

    private func updateFrames(usingPlayerFrames playerFrames: [PlayerFrames]? = nil) {
        framesCollectionViewController?.playerFrames = (playerFrames ?? game.players).map({
            $0.frames.frameInfos.map({
                FrameViewModel(frameInfo: $0)
            })
        })
    }

    private func updateAvailableShots(usingAvailableShots shots: [Shot]? = nil) {
        availableShotsCollectionViewController?.shots = shots ?? game.availableShots()
    }

    private func save() {
        let game = self.game
        self.dataController.performBackgroundTask { (context) in
            do {
                try GameData.updateOrCreateGame(game: game, context: context)

                if context.hasChanges {
                    do {
                        try context.save()
                    } catch {
                        // Can fail if the device storage is full (and a number of other unavoidable reasons)
                        // We should handle this better than creating a stack trace
                        fatalError("Couldn't save changes after creating/updating game: \(error)")
                    }
                }
            } catch {
                fatalError("Couldn't create/update game: \(error)")
            }
        }
    }
}

final class GameViewController: UIViewController {

    var viewModel: GameViewModel?

    @IBOutlet weak var framesCollectionViewHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.framesCollectionViewHeightConstraint = framesCollectionViewHeightConstraint

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
