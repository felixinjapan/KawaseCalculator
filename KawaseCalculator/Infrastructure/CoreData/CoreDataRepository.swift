//
//  CoreDataRepository.swift
//  KawaseCalculator
//
//  Created by Chon, Felix | Felix | MESD on 2022/09/29.
//

import CoreData
import Combine
import os

// MARK: - CoreData Repository

protocol CoreDataRepository {
    var container: NSPersistentContainer { get }
    func fetchCurrencyRates(baseCurrencyEntity: BaseCurrencyEntity) -> [CurrencyEntity]
    func insertBaseCurrencyEntity(base: String) -> BaseCurrencyEntity
    func insertCurrencyEntity(symbol: String, rate: Double, baseCurrencyEntity: BaseCurrencyEntity) -> CurrencyEntity
    func fetchBaseCurrencyEntity(base: String) -> BaseCurrencyEntity?
    func saveData()
    func batchDelete(entityName: String)
}

final class DefaultCoreDataRepository: CoreDataRepository {
    
    let container: NSPersistentContainer
    let logger = Logger(subsystem: Constants.Logging.subsystem.rawValue, category: String(describing: DefaultCoreDataRepository.self))

    init(container: NSPersistentContainer) {
        self.container = container
    }
}

// MARK: - CoreData Repository Implementation

extension DefaultCoreDataRepository {
    func fetchBaseCurrencyEntity(base: String) -> BaseCurrencyEntity? {
        var currencies = [BaseCurrencyEntity]()
        
        let currencyRequest = NSFetchRequest<BaseCurrencyEntity>(entityName: Constants.Coredata.baseCurrencyEntity.rawValue)
        currencyRequest.predicate = NSPredicate(format: "base = %@", base)

        do {
            currencies = try self.container.viewContext.fetch(currencyRequest)
        } catch let error {
            logger.error("fetching base entity with \(base) failed \(String(describing: error))")
        }
        // assuming there is no duplicate row and only single record exists
        return currencies.isEmpty ? nil : currencies.first
    }
    
    func fetchCurrencyRates(baseCurrencyEntity: BaseCurrencyEntity) -> [CurrencyEntity] {
        var currencies = [CurrencyEntity]()

        let currencyRequest = NSFetchRequest<CurrencyEntity>(entityName: Constants.Coredata.currencyEntity.rawValue)
        currencyRequest.predicate = NSPredicate(format: "baseCurrency = %@", baseCurrencyEntity)
        let sortDescriptor = NSSortDescriptor(key: "symbol", ascending: true)
        currencyRequest.sortDescriptors = [sortDescriptor]

        do {
            currencies = try self.container.viewContext.fetch(currencyRequest)
        } catch let error as NSError {
            logger.error("fetching Currency Entity with \(baseCurrencyEntity.unWrappedBase) failed \(String(describing: error))")
        }
        return currencies
    }

    func insertBaseCurrencyEntity(base: String) -> BaseCurrencyEntity {
        let baseCurrencyEntity = BaseCurrencyEntity(context: container.viewContext)
        baseCurrencyEntity.base = base
        return baseCurrencyEntity
    }

    func insertCurrencyEntity(symbol: String, rate: Double, baseCurrencyEntity: BaseCurrencyEntity) -> CurrencyEntity {
        let currencyEntity = CurrencyEntity(context: container.viewContext)
        currencyEntity.symbol = symbol
        currencyEntity.rate = rate
        baseCurrencyEntity.addToCurrencies(currencyEntity)
        return currencyEntity
    }

    func saveData() {
        do {
            try container.viewContext.save()
        } catch let error as NSError {
            logger.error("failed to save \(String(describing: error))")
        }
    }

    func batchDelete(entityName: String) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        fetchRequest = NSFetchRequest(entityName: entityName)

        let deleteRequest = NSBatchDeleteRequest(
            fetchRequest: fetchRequest
        )

        deleteRequest.resultType = .resultTypeObjectIDs
        do {
            // Perform the batch delete
            let batchDelete = try self.container.viewContext.execute(deleteRequest)
            as? NSBatchDeleteResult
            guard let deleteResult = batchDelete?.result
                    as? [NSManagedObjectID]
            else { return }
            let deletedObjects: [AnyHashable: Any] = [
                NSDeletedObjectsKey: deleteResult
            ]
            // Merge the delete changes into the managed
            // object context
            NSManagedObjectContext.mergeChanges(
                fromRemoteContextSave: deletedObjects,
                into: [self.container.viewContext]
            )
        } catch let error {
            logger.error("delete operation failed for \(entityName). \(String(describing: error))")
        }
    }
}
