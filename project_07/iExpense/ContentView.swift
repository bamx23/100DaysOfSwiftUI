//
//  ContentView.swift
//  iExpense
//
//  Created by Nikolay Volosatov on 11/4/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

enum ExpenseType: String, Codable {
    case business = "Business"
    case personal = "Personal"
}

extension ExpenseType: Identifiable {
    var id: String { rawValue }

    static var all: [ExpenseType] {
        return [.business, .personal]
    }
}

struct ExpenseItem: Identifiable, Codable {
    let id: UUID
    let name: String
    let type: ExpenseType
    let amount: Int
}

class Expenses: ObservableObject {
    static let key = "Items"

    @Published var items: [ExpenseItem] {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: Self.key)
            }
        }
    }

    init() {
        if let items = UserDefaults.standard.data(forKey: Self.key) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ExpenseItem].self, from: items) {
                self.items = decoded
                return
            }
        }

        self.items = []
    }
}

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var expenses: Expenses

    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""

    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    func save() {
        guard let actualAmount = Int(amount) else {
            showAlert = true
            alertTitle = "Invalid amount"
            alertMessage = "'\(amount)' is not a valid integer number"
            return
        }
        let expenseType = ExpenseType(rawValue: type)!
        let item = ExpenseItem(id: .init(), name: name, type: expenseType, amount: actualAmount)
        expenses.items.append(item)
        presentationMode.wrappedValue.dismiss()
    }

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(ExpenseType.all) { type in
                        Text(type.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
            .navigationBarTitle("Add new expense")
            .navigationBarItems(trailing: Button("Save", action: save))
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(self.alertTitle),
                  message: Text(self.alertMessage),
                  dismissButton: .default(Text("OK")))
        }
    }
}

struct ExpenseView: View {
    let expense: ExpenseItem

    private var typeView: some View {
        var backgroundColor: Color!
        switch expense.type {
        case .personal:
            backgroundColor = .green
        case .business:
            backgroundColor = .yellow
        }
        return Text(expense.type.rawValue)
            .padding(2)
            .font(.subheadline)
            .background(backgroundColor)
            .foregroundColor(.black)
            .clipShape(RoundedRectangle(cornerRadius: 5))
    }

    private var amountView: some View {
        var backgroundColor: Color!
        var foregroundColor: Color!
        switch expense.amount {
        case 11...100:
            backgroundColor = .blue
            foregroundColor = .white
        case 101...:
            backgroundColor = .yellow
            foregroundColor = .black
        default:
            backgroundColor = .gray
            foregroundColor = .white
        }
        return Text("$\(expense.amount)")
            .padding()
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    var body: some View {
        HStack {
            VStack {
                Text(expense.name)
                    .font(.headline)
                typeView
            }
            Spacer()
            amountView
        }
    }
}

struct ContentView: View {
    @ObservedObject var expenses = Expenses()

    @State private var showingAddExpense = false

    func addExpense() {
        showingAddExpense = true
    }

    func removeExpense(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                    ExpenseView(expense: item)
                }
                .onDelete(perform: removeExpense)
            }
            .navigationBarTitle("iExpense")
            .navigationBarItems(leading: EditButton(),
                                trailing: Button(action: addExpense){ Image(systemName: "plus") })
        }
        .sheet(isPresented: $showingAddExpense) {
            AddView(expenses: self.expenses)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
