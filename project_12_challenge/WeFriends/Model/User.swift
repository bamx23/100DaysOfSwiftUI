//
//  User.swift
//  WeFriends
//
//  Created by Nikolay Volosatov on 11/22/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import Foundation

struct User: Codable, Identifiable {
    typealias ID = UUID

    let id: Self.ID

    let registered: Date
    let isActive: Bool

    let name: String
    let age: Int
    let company: String
    let about: String

    let email: String
    let address: String
    let tags: [String]

    let friends: [Friend]
}

extension User {
    static var sample: User {
        User(
            id: User.ID(),
            registered: Date(),
            isActive: true,
            name: "Nikolay",
            age: 26,
            company: "Yandex",
            about: "iOS Developer. Learing SwiftUI.",
            email: "bamx23@gmail.com",
            address: "Minsk, Belarus",
            tags: ["dev", "yandex"],
            friends: []
        )
    }
}
