//
//  CurrencyMatrixTests.swift
//  exchange-rateTests
//
//  Created by Ionel Lescai on 26.01.2022.
//

import XCTest
@testable import exchange_rate

class CurrencyMatrixTests: XCTestCase {
    let (rates, pairs) = parseMockJson().ratesAndPairs
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testGetAdjacentNodes() {
        let alg = ExchangeRateFillAlgorithm(rates, pairs)
        let sut = alg.getAdjacencyMatrix()
        
        let nodes = sut.getAdjacentNodes(node: "AUD")
        XCTAssertEqual(nodes, ["EUR", "USD"])
    }
    
    func testGetPath() {
        let alg = ExchangeRateFillAlgorithm(rates, pairs)
        let sut = alg.getAdjacencyMatrix()
        
        let path = sut.getPath(from: "AUD", to: "CAD")
        XCTAssertEqual(path, ["AUD", "USD", "CAD"])
    }
    
    func testGetPathConversion() {
        let alg = ExchangeRateFillAlgorithm(rates, pairs)
        let sut = alg.getAdjacencyMatrix()
        
        let path = sut.getPath(from: "AUD", to: "CAD")
        let conversion = sut.getConversion(path: path)
        XCTAssertEqual(conversion, 0.6987)
    }
}
