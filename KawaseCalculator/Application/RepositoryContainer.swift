//
//  AppDIContainer.swift
//  KawaseCalculator
//
//  Created by Chon, Felix | Felix | MESD on 2022/09/25.
//

import Foundation
import CoreData

// MARK: - RepositoryContainer

protocol RepositoryContainer {
    var apiRepository: APIRepository { get }
    var coreDataRepository: CoreDataRepository { get }
    var container: NSPersistentContainer { get }
}

// MARK: - Default Repository Implementation

final class DefaultRepositoryContainer: RepositoryContainer {
    lazy var apiRepository: APIRepository = OERAPIRepository()
    lazy var coreDataRepository: CoreDataRepository = DefaultCoreDataRepository(container: container)

    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.Coredata.nameDataModel.rawValue)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return container
    }()
}
