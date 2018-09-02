//
//  AppCoordinator.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 02/09/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation
import UIKit
import os

final class MainCoordinator {

    init() {

    }

    func createMain() -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .white
        return viewController
    }

    // MARK: - Test Data

    private func prepareGameTestData() -> Game {
        let player1 = FrameCollection(frames: [
            Frame(isFinal: false, shots: [.one, .two])!,
            Frame(isFinal: false, shots: [.three, .four])!,
            Frame(isFinal: false, shots: [.one, .none])!,
            Frame(isFinal: false, shots: [.none, .none])!,
            Frame(isFinal: false, shots: [.strike])!,
            Frame(isFinal: false, shots: [.strike])!,
            Frame(isFinal: false, shots: [.strike])!,
            Frame(isFinal: false, shots: [.strike])!,
            Frame(isFinal: false, shots: [.strike])!,
            Frame(isFinal: true, shots: [.strike, .strike])!
            ])!

        let player2 = FrameCollection(frames: [
            Frame(isFinal: false, shots: [.nine, .none])!,
            Frame(isFinal: false, shots: [.four, .two])!,
            Frame(isFinal: false, shots: [.one, .spare(pinsKnockedDown: .nine)])!,
            Frame(isFinal: false, shots: [.strike])!,
            Frame(isFinal: false, shots: [.strike])!,
            Frame(isFinal: false, shots: [.strike])!,
            Frame(isFinal: false, shots: [.strike])!,
            Frame(isFinal: false, shots: [.strike])!,
            Frame(isFinal: false, shots: [.strike])!,
            Frame(isFinal: true)!
            ])!

        let game = Game(players: [
            PlayerFrames(player: Player(name: "Joshua"), frames: player1),
            PlayerFrames(player: Player(name: "Player 2"), frames: player2)
            ])!

        return game
    }
}

final class AppCoordinator {

    private let window: UIWindow

    private let dataController: CoreDataController!

    private var welcomeCoordinator: WelcomeCoordinator?
    private var mainCoordinator: MainCoordinator?

    init() {
        guard let coreDataController = CoreDataController(options: CoreDataController.Options(name: "BowlingScoreboard")) else {
            fatalError("Couldn't construct core data database")
        }
        dataController = coreDataController

        window = UIWindow(frame: UIScreen.main.bounds)

        // We're using an empty state here, and waiting for core data to load before determining which views to load
        // In an actual production application we'd probably check the keychain for an accessToken to determine whether to show login / registration
        // Checking the keychain instead would avoid the async nature of CoreData
        window.rootViewController = emptyState()
        window.makeKeyAndVisible()

        dataController.loadStore { [unowned self] error in
            if let error = error {
                fatalError("Couldn't load persistent stores due to error: \(error)")
            }

            // Stores loaded, safe to access them
            self.chooseRootViewControllerAsync()
        }
    }

    private func chooseRootViewControllerAsync() {
        dataController.viewContext.perform { [unowned self] in
            let displayWelcome = !UserProfile.exists(context: self.dataController.viewContext)

            DispatchQueue.main.async { [unowned self] in
                if displayWelcome {
                    self.goToWelcome()
                } else {
                    self.goToMainApp()
                }
            }
        }
    }

    private func emptyState() -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .white
        return viewController
    }

    private func goToWelcome() {
        let (welcomeCoordinator, rootViewController) = createWelcome(dataController: dataController) { [unowned self] in
            self.goToMainApp()
            self.welcomeCoordinator = nil
        }

        self.welcomeCoordinator = welcomeCoordinator
        window.rootViewController = rootViewController
    }

    private func goToMainApp() {
        let (mainCoordinator, rootViewController) = createMain()
        self.mainCoordinator = mainCoordinator
        window.rootViewController = rootViewController
    }

    private func createWelcome(dataController: CoreDataController, onFinished: @escaping () -> Void) -> (WelcomeCoordinator, UIViewController) {
        let profileController = ProfileController(dataController: dataController)
        let welcomeCoordinator = WelcomeCoordinator(profileController: profileController)
        let viewController = welcomeCoordinator.createWelcomeFlow(onFinished: onFinished)
        return (welcomeCoordinator, viewController)
    }

    private func createMain() -> (MainCoordinator, UIViewController) {
        let mainCoordinator = MainCoordinator()
        let viewController = mainCoordinator.createMain()
        return (mainCoordinator, viewController)
    }
}
