//
//  ContentView.swift
//  WeSplit
//
//  Created by Nikolay Volosatov on 10/9/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

struct TipModifier: ViewModifier {
    let amount: Double
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(amount.isZero ? Color.red : Color.clear)
            .foregroundColor(amount.isZero ? Color.white : Color.primary)
    }
}

extension View {
    func tipStyle(amount: Double) -> some View {
        self.modifier(TipModifier(amount: amount))
    }
}

struct ContentView: View {

    let tipPercentages = [10, 15, 20, 25, 0]

    @State private var checkAmount = ""
    @State private var numberOfPeople = 2.0
    @State private var tipPercentage = 2

    let localeBasedFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        return formatter
    }()

    var tipAmountFactor: Double { Double(tipPercentages[tipPercentage]) / 100.0 }

    var totalAmount: Double {
        let checkAmountValue = localeBasedFormatter.number(from: checkAmount)?.doubleValue ?? 0.0
        return checkAmountValue * (1.0 + tipAmountFactor)
    }

    var totalPerPerson: Double {
        let peopleCount = numberOfPeople + 2.0
        return totalAmount / peopleCount
    }

    var currencySymbol: String {
        Locale.current.currencySymbol ?? "$"
    }

    func text(withMoneyAmount value: Double) -> some View {
        Text("\(currencySymbol) \(value, specifier: "%.2f")")
            .tipStyle(amount: tipAmountFactor)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Check")) {
                    HStack {
                        Text(currencySymbol)
                        TextField("Amount", text: $checkAmount)
                            .keyboardType(.decimalPad)
                    }
                }
                Section(header: Text("Number of people")) {
                    Text("\(numberOfPeople, specifier: "%.0f") persons")
                    Slider(value: $numberOfPeople, in: 2...20, step: 1)
                }
                Section(header: Text("How much tip do you want to leave?")) {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(0 ..< tipPercentages.count) {
                            Text("\(self.tipPercentages[$0])%")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Total amount for the check")) {
                    text(withMoneyAmount: totalAmount)
                }
                Section(header: Text("Each of you should pay").bold()) {
                    text(withMoneyAmount: totalPerPerson)
                }
            }
            .navigationBarTitle("WeSplit")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
