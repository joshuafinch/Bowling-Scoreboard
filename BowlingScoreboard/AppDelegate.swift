//
//  AppDelegate.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 29/08/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let gameStoryboard = UIStoryboard(name: "Game", bundle: .main)
        let gameViewController = gameStoryboard.instantiateInitialViewController() as? GameViewController
        gameViewController?.viewModel = GameViewModel(game: prepareGameTestData())

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = gameViewController
        window?.makeKeyAndVisible()

        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Test Data

    private func prepareGameTestData() -> Game {
//        let player1 = FrameCollection(frames: [
//            Frame(isFinal: false, shots: [.one, .two])!,
//            Frame(isFinal: false, shots: [.three, .four])!,
//            Frame(isFinal: false, shots: [.one, .none])!,
//            Frame(isFinal: false, shots: [.none, .none])!,
//            Frame(isFinal: false, shots: [.strike])!,
//            Frame()!,
//            Frame()!,
//            Frame()!,
//            Frame()!,
//            Frame(isFinal: true)!
//            ])!
//
//        let player2 = FrameCollection(frames: [
//            Frame(isFinal: false, shots: [.nine, .none])!,
//            Frame(isFinal: false, shots: [.four, .two])!,
//            Frame(isFinal: false, shots: [.one, .spare(pinsKnockedDown: .nine)])!,
//            Frame(isFinal: false, shots: [.strike])!,
//            Frame()!,
//            Frame()!,
//            Frame()!,
//            Frame()!,
//            Frame()!,
//            Frame(isFinal: true)!
//            ])!

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

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BowlingScoreboard")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
