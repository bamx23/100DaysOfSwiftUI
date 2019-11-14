//
//  Order.swift
//  CupcakeCorner
//
//  Created by Nikolay Volosatov on 11/12/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import Foundation

final class Order: ObservableObject, Codable {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    private enum Keys: String, CodingKey {
        case type = "type"
        case quantity = "quantity"
        case extraFrosting = "extra_frosting"
        case addSprinkles = "add_sprinkles"
        case address = "address"
    }

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

    @Published var address = Address()

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

    init() { }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)

        type = try container.decode(Int.self, forKey: .type)
        quantity = try container.decode(Int.self, forKey: .quantity)

        extraFrosting = try container.decode(Bool.self, forKey: .extraFrosting)
        addSprinkles = try container.decode(Bool.self, forKey: .addSprinkles)

        address = try container.decode(Address.self, forKey: .address)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)

        try container.encode(type, forKey: .type)
        try container.encode(quantity, forKey: .quantity)

        try container.encode(extraFrosting, forKey: .extraFrosting)
        try container.encode(addSprinkles, forKey: .addSprinkles)

        try container.encode(address, forKey: .address)
    }

    static var preview: Order {
        let order = Order()
        order.type = 1
        order.quantity = 7
        order.specialRequestEnabled = true
        order.extraFrosting = true

        var address = Address()
        address.name = "Bam"
        address.street_address = "Dzerzhinskaha 5"
        address.city = "Minsk"
        address.zip = "220036"
        order.address = address

        return order
    }
}
