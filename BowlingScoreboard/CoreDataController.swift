//
//  CoreDataController.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 02/09/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataController {

    // MARK: - Nested Types

    struct Options {
        let name: String
        let isReadOnly: Bool = false
        let shouldAddStoreAsynchronously: Bool = true
        let shouldMigrateStoreAutomatically: Bool = true
        let shouldInferMappingModelAutomatically: Bool = true

        func storeDescription(url: URL) -> NSPersistentStoreDescription {
            let description = NSPersistentStoreDescription(url: url)
            description.shouldMigrateStoreAutomatically = shouldMigrateStoreAutomatically
            description.shouldInferMappingModelAutomatically = shouldInferMappingModelAutomatically
            description.shouldAddStoreAsynchronously = shouldAddStoreAsynchronously
            description.isReadOnly = isReadOnly
            return description
        }
    }

    // MARK: - Properties

    private(set) var isStoreLoaded = false

    var viewContext: NSManagedObjectContext {
        precondition(isStoreLoaded, "Persistent stores need to be loaded before accessing the viewContext")
        return persistentContainer.viewContext
    }

    private var options: Options
    private let persistentContainer: NSPersistentContainer

    // MARK: - Initialization

    init?(options: Options, bundle: Bundle = Bundle(for: CoreDataController.self)) {
        guard let managedObjectModel = NSManagedObjectModel.mergedModel(from: [bundle]) else {
            return nil
        }
        self.options = options
        self.persistentContainer = NSPersistentContainer(name: options.name, managedObjectModel: managedObjectModel)
    }

    // MARK: -

    func loadStore(completionHandler: @escaping (Error?) -> Void) {

        if let defaultStoreURL = persistentContainer.persistentStoreDescriptions.compactMap({ $0.url }).first {
            let description = options.storeDescription(url: defaultStoreURL)
            persistentContainer.persistentStoreDescriptions = [description]
        }

        persistentContainer.loadPersistentStores { [weak self] (_, error) in
            if error == nil {
                self?.isStoreLoaded = true
                self?.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
            }

            completionHandler(error)
        }
    }

    func newBackgroundContext() -> NSManagedObjectContext {
        precondition(isStoreLoaded, "Persistent stores need to be loaded before creating a newBackgroundContext")
        return persistentContainer.newBackgroundContext()
    }

    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        precondition(isStoreLoaded, "Persistent stores need to be loaded before performing a background task")
        persistentContainer.performBackgroundTask(block)
    }
}
