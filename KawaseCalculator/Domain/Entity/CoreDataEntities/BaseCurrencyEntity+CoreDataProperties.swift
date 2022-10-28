//
//  BaseCurrencyEntity+CoreDataProperties.swift
//  KawaseCalculator
//
//  Created by Chon, Felix | Felix | MESD on 2022/09/29.
//
//

import Foundation
import CoreData

extension BaseCurrencyEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BaseCurrencyEntity> {
        return NSFetchRequest<BaseCurrencyEntity>(entityName: Constants.Coredata.baseCurrencyEntity.rawValue)
    }

    @NSManaged public var base: String?
    @NSManaged public var currencies: NSSet?

    public var unWrappedBase: String {
        return base ?? Constants.General.unknownCurrency.rawValue
    }
    
    public var currencyArray: [CurrencyEntity] {
        let set = currencies as? Set<CurrencyEntity> ?? []
        return set.sorted {
            $0.unWrappedBase < $1.unWrappedBase
        }
    }
}

// MARK: Generated accessors for currencies
extension BaseCurrencyEntity {

    @objc(addCurrenciesObject:)
    @NSManaged public func addToCurrencies(_ value: CurrencyEntity)

    @objc(removeCurrenciesObject:)
    @NSManaged public func removeFromCurrencies(_ value: CurrencyEntity)

    @objc(addCurrencies:)
    @NSManaged public func addToCurrencies(_ values: NSSet)

    @objc(removeCurrencies:)
    @NSManaged public func removeFromCurrencies(_ values: NSSet)

}

extension BaseCurrencyEntity: Identifiable {

}
