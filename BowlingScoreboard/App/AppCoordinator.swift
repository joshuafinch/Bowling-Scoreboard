//
//  AppCoordinator.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 02/09/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation
import UIKit

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
        window.tintColor = .themeTint
        window.backgroundColor = .themeDark

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
        viewController.view.backgroundColor = .themeDark
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
        let mainCoordinator = MainCoordinator(dataController: dataController)
        let viewController = mainCoordinator.createMain()
        return (mainCoordinator, viewController)
    }
}
