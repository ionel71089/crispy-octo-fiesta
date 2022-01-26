//
//  Types.swift
//  exchange-rate
//
//  Created by Ionel Lescai on 26.01.2022.
//

import Foundation

let formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 2
    formatter.numberStyle = .decimal

    return formatter
}()

typealias Currency = Float
//typealias Currency = Decimal

struct CurrencyPair: Identifiable, Hashable {
    var id: String {
        "\(from) \(to)"
    }
    
    let from: String
    let to: String
    var rate: Currency?
    
    var rateString: String {
        if let rate = rate {
            return formatter.string(from: NSNumber(floatLiteral: Double(rate)))!
        } else {
            return "???"
        }
    }
}
