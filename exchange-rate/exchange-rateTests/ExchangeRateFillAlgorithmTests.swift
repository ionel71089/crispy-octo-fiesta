//
//  ExchangeRateFillAlgorithmTests.swift
//  exchange-rateTests
//
//  Created by Ionel Lescai on 26.01.2022.
//

import XCTest
@testable import exchange_rate

class ExchangeRateFillAlgorithmTests: XCTestCase {
    let (rates, pairs) = parseMockJson().ratesAndPairs

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testGetAllCurrencies() {
        let sut = ExchangeRateFillAlgorithm(rates, pairs)
        XCTAssertEqual(sut.currencies, ["AUD", "CAD", "EUR", "RON", "USD"])
    }
    
    func testGetAdjacencyMatrix() {
        let sut = ExchangeRateFillAlgorithm(rates, pairs)
        let currencies = sut.currencies
        let matrix = sut.getAdjacencyMatrix()
        
        // Test diagonal
        for currency in currencies {
            XCTAssertEqual(matrix[currency, currency], 1)
        }
        
        // Test inital values
        for rate in rates {
            XCTAssertEqual(matrix[rate.from, rate.to], rate.rate)
        }
    }
    
    func testGetFilledPairs() {
        let sut = ExchangeRateFillAlgorithm(rates, pairs)
        let (processedPairs, _) = sut.process()
        
        XCTAssertEqual(processedPairs.count, pairs.uniques.count)
        
        // Test initial pairs are filled
        for rate in rates {
            if let correspondingPair = processedPairs.first(where: { $0.id == rate.id }) {
                XCTAssertEqual(rate.rate, correspondingPair.rate)
            }
        }
    }
    
    func testReverseExchange() {
        let sut = ExchangeRateFillAlgorithm(rates, pairs)
        let matrix = sut.getAdjacencyMatrix()
        
        XCTAssertEqual(matrix["RON", "EUR"], 0.2)
    }
    
    
    func testPairsFilledWithTraversal() {
        let sut = ExchangeRateFillAlgorithm(rates, pairs)
        let (_, matrix) = sut.process()
        
        XCTAssertEqual(matrix["AUD", "CAD"], 0.6987)
    }
}
