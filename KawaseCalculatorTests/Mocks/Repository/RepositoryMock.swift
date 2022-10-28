//
//  RepositoryMock.swift
//  KawaseCalculatorTests
//
//  Created by Chon, Felix | Felix | MESD on 2022/10/02.
//

import Foundation
import CoreData

// MARK: Repository Mock

final class RepositoryMock: RepositoryContainer {
    var apiRepository: APIRepository = APIRepositoryMock()

    var coreDataRepository: CoreDataRepository = CoreDataRepositoryMock()

    var container: NSPersistentContainer = TestCoreDataStack().persistentContainer
}

// MARK: Persistent Container For Testing
// Using in-memory data; will be cleaned as soon as it is deinits
final class TestCoreDataStack: NSObject {
    lazy var persistentContainer: NSPersistentContainer = {
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        let container = NSPersistentContainer(name: "CurrencyContainer")
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
}
