//
//  ContentView.swift
//  iExpense
//
//  Created by Nikolay Volosatov on 11/4/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    let id: UUID
    let name: String
    let type: String
    let amount: Int
}

class Expenses: ObservableObject {
    @Published var items: [ExpenseItem] {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }

    init() {
        if let items = UserDefaults.standard.data(forKey: "Items") {
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

    static let types = ["Business", "Personal"]

    func save() {
        guard let actualAmount = Int(amount) else {
            showAlert = true
            alertTitle = "Invalid amount"
            alertMessage = "'\(amount)' is not a valid integer number"
            return
        }
        let item = ExpenseItem(id: .init(), name: name, type: type, amount: actualAmount)
        expenses.items.append(item)
        presentationMode.wrappedValue.dismiss()
    }

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) { type in
                        Text(type)
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
                Text(expense.type)
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
