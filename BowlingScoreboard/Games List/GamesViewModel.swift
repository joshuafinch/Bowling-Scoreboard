//
//  GamesViewModel.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 03/09/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import os

final class GamesViewModel: NSObject {

    typealias StartNewGame = () -> Void
    typealias SelectedGame = (GameData) -> Void

    var tableView: UITableView? {
        didSet {
            tableView?.dataSource = self
            tableView?.delegate = self
        }
    }

    private let dataController: CoreDataController
    let startNewGame: StartNewGame
    private let selectedGame: SelectedGame

    private var fetchedResultsController: NSFetchedResultsController<GameData>? {
        didSet {
            do {
                try fetchedResultsController?.performFetch()
            } catch {
                os_log("Unable to perform fetch for games: %@",
                       log: Log.general,
                       type: .error,
                       error.localizedDescription)
            }
        }
    }

    init(dataController: CoreDataController,
         onStartNewGame startNewGame: @escaping StartNewGame,
         onSelectedGame selectedGame: @escaping SelectedGame) {
        self.dataController = dataController
        self.startNewGame = startNewGame
        self.selectedGame = selectedGame

        super.init()

        dataController.onLoaded { [weak self] in
            guard let sSelf = self else { return }
            sSelf.fetchedResultsController = sSelf.createFetchedResultsController(context: sSelf.dataController.viewContext)
            sSelf.fetchedResultsController?.delegate = sSelf
        }
    }

    // MARK: -

    private func createFetchedResultsController(context: NSManagedObjectContext) -> NSFetchedResultsController<GameData> {
        let fetchRequest: NSFetchRequest<GameData> = GameData.fetchRequest()

        let sortDescriptor = NSSortDescriptor(key: "startDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)

        return fetchedResultsController
    }
}

extension GamesViewModel: UITableViewDataSource {

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! GameTableViewCell
        configureCell(cell, at: indexPath)
        return cell
    }

    private func configureCell(_ cell: GameTableViewCell, at indexPath: IndexPath) {
        guard let game = fetchedResultsController?.object(at: indexPath) else {
            return
        }

        guard let gameViewModel = GameCellViewModel(gameData: game) else {
            return
        }

        cell.configure(viewModel: gameViewModel)
    }
}

extension GamesViewModel: UITableViewDelegate {

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let game = fetchedResultsController?.object(at: indexPath) else {
            return
        }

        selectedGame(game)
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            if let object = fetchedResultsController?.object(at: indexPath) {
                dataController.viewContext.delete(object)
                do {
                    try dataController.viewContext.save()
                } catch {
                    fatalError("Unable to save deleted object")
                }
            }
        case .insert:
            return
        case .none:
            return
        }
    }
}

extension GamesViewModel: NSFetchedResultsControllerDelegate {

    // MARK: - NSFetchedResultsControllerDelegate

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView?.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView?.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath, let cell = tableView?.cellForRow(at: indexPath) as? GameTableViewCell {
                configureCell(cell, at: indexPath)
            }
        case .move:
            if let indexPath = indexPath {
                tableView?.deleteRows(at: [indexPath], with: .fade)
            }

            if let newIndexPath = newIndexPath {
                tableView?.insertRows(at: [newIndexPath], with: .fade)
            }
        }
    }
}
