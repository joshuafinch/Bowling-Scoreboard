//
//  MainCoordinator.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 03/09/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation
import UIKit

enum GameSettings {
    case onePlayer
    case twoPlayer
}

final class MainCoordinator {

    // MARK: - Properties

    let dataController: CoreDataController

    private var currentPlayer: Player? {
        guard let nickname = UserProfile.currentPlayerName(context: dataController.viewContext) else {
            return nil
        }
        return Player(name: nickname)
    }

    // MARK: - Initialization

    init(dataController: CoreDataController) {
        self.dataController = dataController
    }

    // MARK: -

    func createMain() -> UIViewController {

        let storyboard = UIStoryboard(name: "Games", bundle: .main)

        // swiftlint:disable:next force_cast
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        // swiftlint:disable:next force_cast
        let gamesViewController = navigationController.viewControllers.first as! GamesTableViewController

        let gamesViewModel = GamesViewModel(dataController: dataController, onStartNewGame: { [unowned self] in
            self.chooseGameSettings(presentingViewController: gamesViewController, completionHandler: { (gameSettings) in
                self.start(newGame: gameSettings, navigationController: navigationController)
            })
        }, onSelectedGame: { [unowned self] gameData in
            self.selected(game: gameData, navigationController: navigationController)
        })

        gamesViewController.viewModel = gamesViewModel

        return navigationController
    }

    private func chooseGameSettings(presentingViewController: UIViewController, completionHandler: @escaping (GameSettings) -> Void) {
        let actionSheet = UIAlertController(title: nil, message: "Choose a game mode", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Solo Play", style: .default, handler: { _ in
            completionHandler(.onePlayer)
        }))
        actionSheet.addAction(UIAlertAction(title: "Versus Play", style: .default, handler: { _ in
            completionHandler(.twoPlayer)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        presentingViewController.present(actionSheet, animated: true, completion: nil)
    }

    private func chooseOpponentsName(completionHandler: @escaping (String) -> Void) {
        // TODO: Use the text entry screen to capture the name here
        completionHandler("Bob")
    }

    private func start(newGame gameSettings: GameSettings, navigationController: UINavigationController) {
        guard let currentPlayer = currentPlayer else {
            fatalError("No initial player to start a game with")
        }

        switch gameSettings {
        case .onePlayer:
            startNewGame(players: [currentPlayer], navigationController: navigationController)
        case .twoPlayer:
            chooseOpponentsName { [unowned self] (opponentName) in
                let opposingPlayer = Player(name: opponentName)
                self.startNewGame(players: [currentPlayer, opposingPlayer], navigationController: navigationController)
            }
        }
    }

    private func selected(game gameData: GameData, navigationController: UINavigationController) {
        guard let game = Game(gameData: gameData) else {
            return
        }
        start(game: game, navigationController: navigationController)
    }

    private func startNewGame(players: [Player], navigationController: UINavigationController) {
        let playerFrames = players.map({ PlayerFrames(player: $0, frames: FrameCollection()!) })
        let game = Game(players: playerFrames)!
        start(game: game, navigationController: navigationController)
    }

    private func start(game: Game, navigationController: UINavigationController) {
        let storyboard = UIStoryboard(name: "Game", bundle: .main)
        // swiftlint:disable:next force_cast
        let gameViewController = storyboard.instantiateInitialViewController() as! GameViewController
        let gameViewModel = GameViewModel(game: game, dataController: dataController)
        gameViewController.viewModel = gameViewModel
        navigationController.pushViewController(gameViewController, animated: true)
    }
}
