//
//  exchange_rateApp.swift
//  exchange-rate
//
//  Created by Ionel Lescai on 26.01.2022.
//

import SwiftUI

@main
struct exchange_rateApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(service: ExchangeService())
        }
    }
}
