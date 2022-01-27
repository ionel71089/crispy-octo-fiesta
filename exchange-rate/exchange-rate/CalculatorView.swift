//
//  CalculatorView.swift
//  exchange-rate
//
//  Created by Ionel Lescai on 27.01.2022.
//

import SwiftUI
import Combine

let selectedRowColor = Color.green
let defaultRowColor = Color(UIColor.secondarySystemGroupedBackground)

class CalculatorViewModel: ObservableObject {
    let matrix: CurrencyMatrix
    var currencies: [String] {
        matrix.currencies
    }
    
    @Published var selection: String?
    @Published var values: [Float]
    
    var disposeBag = Set<AnyCancellable>()
    
    init(currencyMatrix: CurrencyMatrix) {
        matrix = currencyMatrix
        values = Array(repeating: 0, count: matrix.currencies.count)
    }
    
    func index(_ currency: String) -> Int {
        currencies.firstIndex(of: currency)!
    }
    
    func recalculate(selection: String) {
        let value = values[index(selection)]
        var newValues = values
        for (index, currency) in currencies.enumerated() {
            guard currency != selection else { continue }
            
            newValues[index] = value * matrix[selection, currency]
        }
        
        values = newValues
    }
}

struct CalculatorView: View {
    @StateObject var viewModel: CalculatorViewModel
    
    init(currencyMatrix: CurrencyMatrix) {
        _viewModel = .init(wrappedValue: CalculatorViewModel(currencyMatrix: currencyMatrix))
    }
    
    var body: some View {
        List(viewModel.currencies, id: \.self, selection: $viewModel.selection) { currency in
            HStack {
                CurrencyFlagView(currency: currency)
                
                Spacer()
                
                
                TextField(value: $viewModel.values[viewModel.index(currency)], formatter: formatter, prompt: nil) {
                    EmptyView()
                }
                .disabled(!(viewModel.selection == nil || viewModel.selection == currency))
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .font(.title2)
                
                
                Text(currency)
                    .font(.title2)
                
                Spacer().frame(width: 32)
                
                Button(action: {
                    print("Hello")
                }) {
                    Image(systemName: "square.on.square")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 24)
                }
                .tint(.gray)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                if viewModel.selection == nil {
                    viewModel.selection = currency
                }
            }
            .listRowBackground(currency == viewModel.selection ? selectedRowColor : defaultRowColor)
        }
        .navigationBarItems(trailing: doneButton)
    }
    
    var doneButton: some View {
        if let selection = viewModel.selection {
            return AnyView(Button(action: {
                viewModel.recalculate(selection: selection)
                viewModel.selection = nil
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }) {
                Image(systemName: "checkmark.circle")
            })
        } else {
            return AnyView(EmptyView())
        }
    }
    
    var noButton: some View {
        EmptyView()
    }
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CalculatorView(currencyMatrix: CurrencyMatrix(currencies: ["AUD", "CAD", "EUR", "RON", "USD"]))
                .navigationTitle("Calculator")
        }
    }
}
