//
//  User.swift
//  WeFriends
//
//  Created by Nikolay Volosatov on 11/22/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import Foundation
import CoreData

extension User: Identifiable {
//    static var sample: User {
//        User(
//            id: UUID(),
//            registered: Date(),
//            isActive: true,
//            name: "Nikolay",
//            age: 26,
//            company: "Yandex",
//            about: "iOS Developer. Learing SwiftUI.",
//            email: "bamx23@gmail.com",
//            address: "Minsk, Belarus",
//            tags: ["dev", "yandex"],
//            friends: []
//        )
//    }
//
//    ini

    var wrappedName: String { name ?? "Unknown" }
    var wrappedAge: Int { Int(age) }

    var wrappedCompany: String { company ?? "Unknown" }
    var wrappedAbout: String { about ?? "No information" }
    var wrappedEmail: String { email ?? "Unknown email" }
    var wrappedAddress: String { address ?? "Unknown address" }

    var formattedRegistered: String {
        guard let registered = registered else {
            return "unknown"
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        return formatter.string(from: registered)
    }

    var tagsArray: [String] {
        let tagsSet = tags as? Set<Tag> ?? []
        return tagsSet
            .map { $0.name ?? "" }
            .filter { $0.count != 0 }
            .sorted()
    }

    var friendsArray: [User] {
        let friendsSet = friends as? Set<Friend> ?? []
        return friendsSet
            .flatMap { $0.target != nil ? [$0.target!] : [] }
            .sorted { ($0.name ?? "") < ($1.name ?? "") }
    }
}
