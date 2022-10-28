//
//  CurrencyEntity+CoreDataProperties.swift
//  KawaseCalculator
//
//  Created by Chon, Felix | Felix | MESD on 2022/09/29.
//
//

import Foundation
import CoreData

extension CurrencyEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrencyEntity> {
        return NSFetchRequest<CurrencyEntity>(entityName: Constants.Coredata.currencyEntity.rawValue)
    }

    @NSManaged public var symbol: String?
    @NSManaged public var rate: Double
    @NSManaged public var baseCurrency: BaseCurrencyEntity?

    public var unwrappedSymbol: String {
        return symbol ?? Constants.General.unknownCurrency.rawValue
    }
}
