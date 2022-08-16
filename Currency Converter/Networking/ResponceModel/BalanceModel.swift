//
//  BalanceModel.swift
//  Currency Converter
//
//  Created by 4steps on 16.08.22.
//

import Foundation

struct BalanceModel {
    
    let currencyName: String
    let currencyBalance: Double
    
    static func createTempModel() -> [BalanceModel] {
        let myBalances = [
        BalanceModel(currencyName: "EUR", currencyBalance: 100),
        BalanceModel(currencyName: "USD", currencyBalance: 150),
        BalanceModel(currencyName: "RUB", currencyBalance: 1000),
        BalanceModel(currencyName: "AMD", currencyBalance: 20000),
        BalanceModel(currencyName: "GEL", currencyBalance: 220),
        ]
        return myBalances
    }
}

enum DestinationType {
    case toCurrency
    case fromCurrency
}
