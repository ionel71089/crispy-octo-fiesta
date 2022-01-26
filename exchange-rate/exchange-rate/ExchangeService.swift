//
//  ExchangeService.swift
//  exchange-rate
//
//  Created by Ionel Lescai on 26.01.2022.
//

import Foundation

protocol ExchangeServiceProtocol {
    func getPairs() async -> [CurrencyPair]
}

class ExchangeService: ExchangeServiceProtocol {
    let pairsURL = URL(string: "http://gnb.dev.airtouchmedia.com/rates2.json")!
    
    struct Response: Decodable {
        let rates: [CurrencyPairJson]
        let pairs: [CurrencyPairJson]
    }
    
    struct CurrencyPairJson: Decodable {
        let from: String
        let to: String
        let rate: String?
        
        func toCurrencyPair() -> CurrencyPair {
            CurrencyPair(from: from,
                         to: to,
                         rate: rate.flatMap { Float($0) })
        }
    }
    
    func getPairs() async -> [CurrencyPair] {
        do {
            let (data, _) = try await URLSession.shared.data(from: pairsURL)
            let response = try JSONDecoder().decode(Response.self, from: data)
            
            // TODO: process pairs
            
            return response.pairs.map { $0.toCurrencyPair() }
        } catch {
            print(error)
        }
        
        return []
    }
}
