//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Nikolay Volosatov on 11/13/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: Order

    @State private var showingConfirmation = false
    @State private var confirmationMessage = ""
    @State private var confirmationTitle = ""

    func fillMessage(_ string: String, title: String) {
        confirmationMessage = string
        confirmationTitle = title
        showingConfirmation = true
    }

    func fillError(_ string: String) {
        fillMessage(string, title: "Oops!")
    }

    func placeOrder() {
        guard let requestBody = try? JSONEncoder().encode(order) else {
            self.fillError("Failed to encode request")
            return
        }

        var request = URLRequest(url: URL(string: "https://reqres.in/api/cupcakes")!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = requestBody

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil, let data = data, let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                self.fillError("Request failed: \(error?.localizedDescription ?? "unknown problem")")
                return
            }
            guard (200..<300).contains(statusCode) else {
                self.fillError("Request failed with HTTP code: \(statusCode)")
                return
            }
            guard let decodedOrder = try? JSONDecoder().decode(Order.self, from: data) else {
                self.fillError("Invalid response from server")
                return
            }
            let quantity = decodedOrder.quantity
            let typeName = Order.types[decodedOrder.type].lowercased()
            self.fillMessage("Your order for \(quantity)x \(typeName) cupcakes is on its way!", title: "Thank you!")
        }.resume()
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    Image("cupcakes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)
                        .accessibility(hidden: true)

                    Text("Your total is $\(self.order.cost, specifier: "%.2f")")
                        .font(.title)

                    Button("Place Order") {
                        self.placeOrder()
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitle("Check out", displayMode: .inline)
        .alert(isPresented: $showingConfirmation) {
            Alert(title: Text(confirmationTitle),
                  message: Text(confirmationMessage),
                  dismissButton: .default(Text("OK")))
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CheckoutView(order: Order.preview)
        }
    }
}
