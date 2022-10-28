//
//  CoreDataRepositoryMock.swift
//  KawaseCalculatorTests
//
//  Created by Chon, Felix | Felix | MESD on 2022/10/02.
//

import Foundation
import CoreData

class CoreDataRepositoryMock: CoreDataRepository {
    var container: NSPersistentContainer = NSPersistentContainer(name: "")

    func fetchCurrencyRates(baseCurrencyEntity: BaseCurrencyEntity) -> [CurrencyEntity] {
        return [CurrencyEntityMock()]
    }

    func insertBaseCurrencyEntity(base: String) -> BaseCurrencyEntity {
        return BaseCurrencyEntityMock(name: base)
    }

    func insertCurrencyEntity(symbol: String, rate: Double, baseCurrencyEntity: BaseCurrencyEntity) -> CurrencyEntity {
        return CurrencyEntityMock(name: symbol, rate: rate)
    }

    func fetchBaseCurrencyEntity(base: String) -> BaseCurrencyEntity? {
        return BaseCurrencyEntityMock(name: base)
    }

    func saveData() {
    }

    func batchDelete(entityName: String) {
    }

}
final class CoreDataRepository_NoBaseEntityFoundMock: CoreDataRepositoryMock {
    override func fetchBaseCurrencyEntity(base: String) -> BaseCurrencyEntity? {
        return nil
    }
}
