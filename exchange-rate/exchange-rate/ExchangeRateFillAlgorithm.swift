//
//  ExchangeRateFillAlgorithm.swift
//  exchange-rate
//
//  Created by Ionel Lescai on 26.01.2022.
//

import Foundation

struct CurrencyMatrix {
    let currencies: [String]
    private var matrix: Matrix<Currency>
    
    init(currencies: [String]) {
        self.currencies = currencies
        self.matrix = Matrix(repeating: 0,
                             numberOfRows: currencies.count,
                             numberOfColumns: currencies.count)
        for currency in currencies {
            self[currency, currency] = 1
        }
    }
    
    private func index(of currency: String) -> Int {
        currencies.firstIndex(of: currency)!
    }
    
    subscript(from: String, to: String) -> Currency {
        get {
            matrix[index(of: from), index(of: to)]
        }
        set {
            matrix[index(of: from), index(of: to)] = newValue
            
            // fill in inverse rate
            if self[to, from] == 0, newValue != 0 {
                self[to, from] = 1 / newValue
            }
        }
    }
    
    func countZero() -> Int {
        matrix.elements.filter { $0 == 0 }.count
    }
    
    func getPath(from start: String, to end: String) -> [String] {
        guard currencies.contains(start) && currencies.contains(end) else {
            return []
        }
        
        return getSubPath(path: [start], to: end)
    }
    
    private func getSubPath(path: [String], to end: String) -> [String] {
        let currentNode = path.last!
        
        guard currentNode != end else {
            return path
        }
        
        var paths = [[String]]()
        
        for nextChild in getAdjacentNodes(node: currentNode) {
            guard !path.contains(nextChild) else {
                continue
            }
            
            let newPath = getSubPath(path: path + [nextChild], to: end)
            if newPath.last == end {
                paths.append(newPath)
            }
        }
        
        return paths.sorted { $0.count < $1.count }.first ?? []
    }
    
    func getAdjacentNodes(node: String) -> [String] {
        currencies
            .filter { currency in
                currency != node && self[node, currency] != 0
            }
    }
    
    func getConversion(path: [String]) -> Currency {
        var path = path
        guard path.count > 2 else { fatalError("Path too short") }
        
        var from = path.removeFirst()
        var to = path.removeFirst()
        var conversion = self[from, to]
        
        while !path.isEmpty {
            (from, to) = (to, path.removeFirst())
            conversion *= self[from, to]
        }
        
        return conversion
    }
}

extension Array where Element == CurrencyPair {
    subscript(from: String, to: String) -> CurrencyPair? {
        let id = "\(from) \(to)"
        return first(where: { $0.id == id })
    }
}

class ExchangeRateFillAlgorithm {
    let rates: [CurrencyPair]
    let pairs: [CurrencyPair]
    var currencies = [String]()
    
    init(_ rates: [CurrencyPair], _ pairs: [CurrencyPair]) {
        self.rates = rates
        self.pairs = pairs
        currencies = getAllCurrencies()
    }
    
    func process() -> ([CurrencyPair], CurrencyMatrix) {
        var matrix = getAdjacencyMatrix()
        
        for (fromIndex, from) in currencies.enumerated() {
            for (toIndex, to) in currencies.enumerated() {
                guard fromIndex < toIndex else {
                    continue;
                }
                
                if matrix[from, to] == 0 {
                    let path = matrix.getPath(from: from, to: to)
                    let conversion = matrix.getConversion(path: path)
                    matrix[from, to] = conversion
                }
            }
        }
        
        return (pairs.map {
            var pair = $0
            pair.rate = matrix[pair.from, pair.to]
            return pair
        }.uniques, matrix)
    }
    
    private func getAllCurrencies() -> [String] {
        let allItems = (rates + pairs).flatMap { [$0.to, $0.from] }
        return Array(Set(allItems)).sorted()
    }
    
    func getAdjacencyMatrix() -> CurrencyMatrix {
        var matrix = CurrencyMatrix(currencies: currencies)
        
        // fill known rates
        for rate in rates {
            matrix[rate.from, rate.to] = rate.rate!
        }
        
        return matrix
    }
}

extension Array where Element: Hashable {

    /// Big O(N) version. Updated since @Adrian's comment.
    var uniques: Array {
        // Go front to back, add element to buffer if it isn't a repeat.
         var buffer: [Element] = []
         var dictionary: [Element: Int] = [:]
         for element in self where dictionary[element] == nil {
             buffer.append(element)
             dictionary[element] = 1
         }
         return buffer
    }
}
