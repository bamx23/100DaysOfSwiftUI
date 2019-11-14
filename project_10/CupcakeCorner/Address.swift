//
//  Address.swift
//  CupcakeCorner
//
//  Created by Nikolay Volosatov on 11/13/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import Foundation

extension String {
    var isEmptyOrWhitespaced: Bool {
        isEmpty || trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

struct Address: Codable, Identifiable {
    var name = ""
    var street_address = ""
    var city = ""
    var zip = ""

    var id: String {
        "\(name): \(street_address), \(city), \(zip)"
    }
    var isValid: Bool {
        [name, street_address, city, zip].filter{ $0.isEmptyOrWhitespaced }.isEmpty
    }
}
