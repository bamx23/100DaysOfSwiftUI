//
//  Order.swift
//  CupcakeCorner
//
//  Created by Nikolay Volosatov on 11/12/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import Foundation

class Order: ObservableObject {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]

    @Published var type = 0
    @Published var quantity = 3

    @Published var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    
    @Published var extraFrosting = false
    @Published var addSprinkles = false

    @Published var name = ""
    @Published var streetAddress = ""
    @Published var city = ""
    @Published var zip = ""

    var hasValidAddress: Bool {
        (name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty) == false
    }
    var cost: Double {
        // $2 per cake
        var cost = Double(quantity) * 2

        // complicated cakes cost more
        cost += (Double(type) / 2)

        // $1/cake for extra frosting
        if extraFrosting {
            cost += Double(quantity)
        }

        // $0.50/cake for sprinkles
        if addSprinkles {
            cost += Double(quantity) / 2
        }

        return cost
    }

    static var preview: Order {
        let order = Order()
        order.type = 1
        order.quantity = 7
        order.specialRequestEnabled = true
        order.extraFrosting = true
        
        order.name = "Bam"
        order.streetAddress = "Dzerzhinskaha 5"
        order.city = "Minsk"
        order.zip = "220036"
        return order
    }
}
