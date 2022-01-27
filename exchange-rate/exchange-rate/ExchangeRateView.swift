//
//  ExchangeRateView.swift
//  exchange-rate
//
//  Created by Ionel Lescai on 27.01.2022.
//

import SwiftUI

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

struct ExchangeRateView_Previews: PreviewProvider {
    static var previews: some View {
        ExchangeRateView(pairs: parseMockData().0)
    }
}
