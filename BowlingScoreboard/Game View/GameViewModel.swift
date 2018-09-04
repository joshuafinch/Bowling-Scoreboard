//
//  GameViewModel.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 03/09/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import UIKit
import os

class GameViewModel: GameDelegate, TakeShotDelegate {

    var playerOneLabel: UILabel? {
        didSet {
            updatePlayerOneLabel()
        }
    }

    var playerTwoLabel: UILabel? {
        didSet {
            updatePlayerTwoLabel()
        }
    }

    var turnToShootMessage: UILabel? {
        didSet {
            updateTurnToShootMessage()
        }
    }

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
            let heightPerPlayer = FramesCollectionViewFlowLayout.Constants.itemSize.height
                + FramesCollectionViewFlowLayout.Constants.frameHeaderSize.height
                + FramesCollectionViewFlowLayout.Constants.lineSpacing
            framesCollectionViewHeightConstraint?.constant = heightPerPlayer * CGFloat(game.players.count) +
                (FramesCollectionViewFlowLayout.Constants.sectionSpacing * CGFloat(game.players.count - 1))
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
        updateTurnToShootMessage()
    }

    func gameFinished() {
        updateTurnToShootMessage()
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

    private func updatePlayerOneLabel() {
        guard !game.players.isEmpty else {
            playerOneLabel?.text = nil
            return
        }
        playerOneLabel?.text = game.players[0].player.name
    }

    private func updatePlayerTwoLabel() {
        guard game.players.count > 1 else {
            playerTwoLabel?.text = nil
            return
        }
        playerTwoLabel?.text = game.players[1].player.name
    }

    private func updateTurnToShootMessage() {
        if let winner = game.winner() {

            switch winner {
            case .player(let player, let score):
                turnToShootMessage?.text = "\(player.name) won the game with a score of \(score)"
            case .draw(let score):
                turnToShootMessage?.text = "The game resulted in a draw with a score of \(score)"
            }
        } else {
            turnToShootMessage?.text = "\(game.currentPlayer.player.name)'s turn to shoot"
        }
    }

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
