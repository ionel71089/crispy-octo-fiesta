//
//  ContentView.swift
//  exchange-rate
//
//  Created by Ionel Lescai on 26.01.2022.
//

import SwiftUI

private var mockPairs = [1, 2, 3].map { CurrencyPair(from: "TEST\($0)", to: "TEST", rate: nil) }

struct ContentView: View {
    var service: ExchangeServiceProtocol
    
    @State private var pairs: [CurrencyPair] = mockPairs
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
                CalculatorView()
                    .navigationTitle("Calculator")
            }
            .tag(2)
            .tabItem {
                Image(systemName: "calendar.circle.fill")
                Text("Calculator")
            }
        }
        .task {
            (pairs, _) = await service.getPairs()
            isLoading = false
        }
        .refreshable {
            isLoading = true
            pairs = mockPairs
            (pairs, _) = await service.getPairs()
            isLoading = false
        }
    }
}

struct ExchangeRateView: View {
    var pairs: [CurrencyPair]
    
    var body: some View {
        List {
            ForEach(pairs) { pair in
                HStack(spacing: 30) {
                    Spacer()
                    CurrencyView(currency: pair.from)
                    Text(pair.rateString)
                    CurrencyView(currency: pair.to)
                    Spacer()
                }
            }
        }
    }
}

struct CurrencyView: View {
    var currency: String
    
    var body: some View {
        VStack {
            if let flagUrl = getCountryFlagUrl(currency: currency) {
                AsyncImage(url: flagUrl)
                    .frame(width: 40, height: 40)
            } else {
                Image(systemName: "flag.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
            }
            
            Text(currency)
                .font(.headline)
        }
    }
}

struct CalculatorView: View {
    var body: some View {
        Text("CalculatorView")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(service: MockExchangeService())
    }
}
