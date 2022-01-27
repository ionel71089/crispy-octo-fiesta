//
//  CurrencyView.swift
//  exchange-rate
//
//  Created by Ionel Lescai on 27.01.2022.
//

import SwiftUI

struct CurrencyView: View {
    var currency: String
    
    var body: some View {
        VStack {
            CurrencyFlagView(currency: currency)
            
            Text(currency)
                .font(.headline)
        }
    }
}

struct CurrencyFlagView: View {
    var currency: String
    
    var body: some View {
        if let flagUrl = getCountryFlagUrl(currency: currency) {
            AsyncImage(url: flagUrl)
                .frame(width: 40, height: 40)
        } else {
            Image(systemName: "flag.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
        }
    }
}

struct CurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyView(currency: "USD")
    }
}
