//
//  User.swift
//  WeFriends
//
//  Created by Nikolay Volosatov on 11/22/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import Foundation

struct User: Codable, Identifiable {
    let id: UUID

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
