//
//  Address.swift
//  CupcakeCorner
//
//  Created by Nikolay Volosatov on 11/13/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import Foundation

final class Address: ObservableObject, Codable, Identifiable {
    private enum Keys: String, CodingKey {
        case name = "name"
        case streetAddress = "street_address"
        case city = "city"
        case zip = "zip"
    }

    @Published var name = ""
    @Published var streetAddress = ""
    @Published var city = ""
    @Published var zip = ""

    var id: String {
        "\(name): \(streetAddress), \(city), \(zip)"
    }
    var isValid: Bool {
        (name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty) == false
    }

    init() { }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)

        name = try container.decode(String.self, forKey: .name)
        streetAddress = try container.decode(String.self, forKey: .streetAddress)
        city = try container.decode(String.self, forKey: .city)
        zip = try container.decode(String.self, forKey: .zip)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)

        try container.encode(name, forKey: .name)
        try container.encode(streetAddress, forKey: .streetAddress)
        try container.encode(city, forKey: .city)
        try container.encode(zip, forKey: .zip)
    }

    func clone() -> Address {
        var result = Address()
        result.name = name
        result.streetAddress = streetAddress
        result.city = city
        result.zip = zip
        return result
    }
}
