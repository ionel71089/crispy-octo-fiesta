//
//  Types.swift
//  exchange-rate
//
//  Created by Ionel Lescai on 26.01.2022.
//

import Foundation

struct CurrencyPair: Identifiable {
    var id: String {
        "\(from) \(to)"
    }
    
    let from: String
    let to: String
    var rate: Float?
    
    var rateString: String {
        if let rate = rate {
            return "\(rate)"
        } else {
            return "???"
        }
    }
}
