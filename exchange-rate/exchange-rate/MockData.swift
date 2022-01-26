//
//  MockData.swift
//  exchange-rate
//
//  Created by Ionel Lescai on 26.01.2022.
//

import Foundation

func parseMockJson() -> ExchangeService.Response {
    try! JSONDecoder().decode(ExchangeService.Response.self, from: mockJsonData)
}

class MockExchangeService: ExchangeServiceProtocol {
    func getPairs() async -> ([CurrencyPair], CurrencyMatrix) {
        (parseMockJson().pairs.map { $0.toCurrencyPair() }, CurrencyMatrix(currencies: []))
    }
}

let mockJsonData = """
{
  "rates": [
    {
      "from": "AUD",
      "to": "USD",
      "rate": "1.37"
    },
    {
      "from": "USD",
      "to": "AUD",
      "rate": "0.73"
    },
    {
      "from": "AUD",
      "to": "EUR",
      "rate": "1.05"
    },
    {
      "from": "EUR",
      "to": "AUD",
      "rate": "0.95"
    },
    {
      "from": "USD",
      "to": "CAD",
      "rate": "0.51"
    },
    {
      "from": "CAD",
      "to": "USD",
      "rate": "1.96"
    },
    {
      "from": "EUR",
      "to": "RON",
      "rate": "5.00"
    }
  ],
  "pairs": [
    {
      "from": "USD",
      "to": "AUD"
    },
    {
      "from": "CAD",
      "to": "AUD"
    },
    {
      "from": "EUR",
      "to": "CAD"
    },
    {
      "from": "USD",
      "to": "AUD"
    },
    {
      "from": "AUD",
      "to": "EUR"
    },
    {
      "from": "EUR",
      "to": "AUD"
    },
    {
      "from": "AUD",
      "to": "USD"
    },
    {
      "from": "CAD",
      "to": "USD"
    },
    {
      "from": "CAD",
      "to": "EUR"
    },
    {
      "from": "USD",
      "to": "RON"
    }
  ]
}
""".data(using: .utf8)!
