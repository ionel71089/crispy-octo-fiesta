//
//  ExchangeService.swift
//  exchange-rate
//
//  Created by Ionel Lescai on 26.01.2022.
//

import Foundation

protocol ExchangeServiceProtocol {
    func getPairs() async -> ([CurrencyPair], CurrencyMatrix)
}

private func convert(_ string: String) -> Currency? {
//    let currency = Decimal(string: string) ?? 0
//    return currency
    
    Float(string)
}

class ExchangeService: ExchangeServiceProtocol {
    let pairsURL = URL(string: "http://gnb.dev.airtouchmedia.com/rates2.json")!
    
    struct Response: Decodable {
        let rates: [CurrencyRate]
        let pairs: [CurrencyPairJson]
        
        var ratesAndPairs: ([CurrencyPair], [CurrencyPair]) {
            (rates: rates.map { $0.toCurrencyPair() },
             pairs: pairs.map { $0.toCurrencyPair() })
        }
    }
    
    struct CurrencyRate: Decodable {
        let from: String
        let to: String
        let rate: String
        
        func toCurrencyPair() -> CurrencyPair {
            CurrencyPair(from: from,
                         to: to,
                         rate: convert(rate) ?? 0) // TODO: treat if string isn't number
        }
    }
    
    struct CurrencyPairJson: Decodable {
        let from: String
        let to: String
        let rate: String?
        
        func toCurrencyPair() -> CurrencyPair {
            CurrencyPair(from: from,
                         to: to,
                         rate: rate.flatMap { convert($0) })
        }
    }
    
    func getPairs() async -> ([CurrencyPair], CurrencyMatrix) {
        do {
            let (data, _) = try await URLSession.shared.data(from: pairsURL)
            let response = try JSONDecoder().decode(Response.self, from: data)
            
            let (rates, pairs) = response.ratesAndPairs
            let algorithm = ExchangeRateFillAlgorithm(rates, pairs)
            
            return algorithm.process()
        } catch {
            print(error)
        }
        
        return ([], CurrencyMatrix(currencies: []))
    }
}
