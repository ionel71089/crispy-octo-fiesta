//
//  CurrencyPairTests.swift
//  exchange-rateTests
//
//  Created by Ionel Lescai on 26.01.2022.
//

import XCTest
@testable import exchange_rate

class CurrencyPairTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testParsing() throws {
        let jsonData = """
{
  "rates": [
    {
      "from": "AUD",
      "to": "USD",
      "rate": "1.37"
    }
  ],
  "pairs": [
    {
      "from": "USD",
      "to": "AUD"
    }
  ]
}
""".data(using: .utf8)!
        
        let result = try JSONDecoder().decode(ExchangeService.Response.self, from: jsonData)
        
        XCTAssertEqual(result.rates.count, 1)
        XCTAssertEqual(result.pairs.count, 1)
    }
}
