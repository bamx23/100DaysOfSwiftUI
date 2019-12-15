//
//  ContentView.swift
//  BetterRest
//
//  Created by Nikolay Volosatov on 10/21/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

extension Date {
    func formatted() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = .current
        let dateString = formatter.string(from: Date())
        return dateString
    }
}

struct ContentView: View {
    let model = BetterRest()

    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1

    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false

    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }

    func calculateBedtime() -> String? {
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60

        do {
            let result = try model.prediction(
                feature_0: Double(hour + minute),
                feature_1: sleepAmount,
                feature_2: Double(coffeeAmount)
            )
            let sleepTime = wakeUp - result.prediction[0].doubleValue

            let formatter = DateFormatter()
            formatter.timeStyle = .short

            return formatter.string(from: sleepTime)
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
            wakeUp = Self.defaultWakeTime
            sleepAmount = 8.0
            coffeeAmount = 1
            showingAlert = true
        }
        return nil
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack {
                        Text("When do you want to wake up?")
                            .font(.headline)

                        DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .datePickerStyle(WheelDatePickerStyle())
                    }

                    VStack {
                        Text("Desired amount of sleep")
                            .font(.headline)

                        Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                            Text("\(sleepAmount, specifier: "%g") hours")
                        }
                        .accessibility(label: Text("Amount of sleep"))
                        .accessibility(value: Text("\(sleepAmount, specifier: "%g") hours"))
                    }

                    VStack {
                        Text("Daily coffee intake")
                            .font(.headline)

                        Picker("Coffee amount", selection: $coffeeAmount) {
                            ForEach(0..<21) { amount in
                                if amount == 0 {
                                    Text("no coffee")
                                } else if amount == 1 {
                                    Text("1 cup")
                                } else {
                                    Text("\(amount) cups")
                                }
                            }
                        }
                    }
                }

                Section {
                    VStack {
                        Text("Your ideal bedtime is")
                            .font(.headline)
                        Text(calculateBedtime() ?? "...")
                            .font(.largeTitle)
                    }
                    .frame(maxWidth: .infinity)
                    .accessibilityElement(children: .combine)
                }
            }
            .padding()
            .navigationBarTitle("BetterRest")
        }.alert(isPresented: $showingAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
