//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Nikolay Volosatov on 11/13/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

struct AddressView: View {
    @EnvironmentObject var addressBook: AddressBook
    
    @ObservedObject var order: Order

    var body: some View {
        Form {
            Section(header: Text("Address book")) {
                List {
                    ForEach(addressBook.list) { address in
                        Button(address.id) {
                            self.order.address = address
                        }
                    }
                    .onDelete(perform: { self.addressBook.list.remove(atOffsets: $0) })
                }
            }
            Section(header: Text("New address")) {
                TextField("Name", text: $order.address.name)
                TextField("Street Address", text: $order.address.street_address)
                TextField("City", text: $order.address.city)
                TextField("Zip", text: $order.address.zip)

                Button("Add to address book") {
                    self.addressBook.list.append(self.order.address)
                }
                .disabled(order.address.isValid == false)
            }

            Section {
                NavigationLink(destination: CheckoutView(order: order)) {
                    Text("Check out")
                }
                .disabled(order.address.isValid == false)
            }
        }
        .navigationBarTitle("Delivery details", displayMode: .inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddressView(order: Order.preview)
        }
    }
}
