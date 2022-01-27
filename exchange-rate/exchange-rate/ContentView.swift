//
//  ContentView.swift
//  exchange-rate
//
//  Created by Ionel Lescai on 26.01.2022.
//

import SwiftUI

private var mockPairs = [1, 2, 3].map { CurrencyPair(from: "TEST\($0)", to: "TEST", rate: nil) }
private var mockCurrencyMatrix = CurrencyMatrix(currencies: [1, 2, 3].map { "TEST\($0)" })

struct ContentView: View {
    var service: ExchangeServiceProtocol
    
    @State private var pairs: [CurrencyPair] = mockPairs
    @State private var currencyMatrix: CurrencyMatrix = mockCurrencyMatrix
    @State private var isLoading: Bool = true
    
    var body: some View {
        TabView {
            NavigationView {
                ExchangeRateView(pairs: pairs)
                    .redacted(reason: isLoading ? .placeholder : [])
                    .navigationTitle("Exchange Rate")
            }
            .tag(1)
            .tabItem {
                Image(systemName: "dollarsign.circle.fill")
                Text("Exchange Rate")
            }
            
            NavigationView {
                CalculatorView(currencyMatrix: currencyMatrix)
                    .navigationTitle("Calculator")
            }
            .tag(2)
            .tabItem {
                Image(systemName: "calendar.circle.fill")
                Text("Calculator")
            }
        }
        .task {
            (pairs, currencyMatrix) = await service.getPairs()
            isLoading = false
        }
        .refreshable {
            isLoading = true
            pairs = mockPairs
            currencyMatrix = mockCurrencyMatrix
            (pairs, currencyMatrix) = await service.getPairs()
            isLoading = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(service: MockExchangeService())
    }
}
