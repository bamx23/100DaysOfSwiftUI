//
//  Storage.swift
//  WeFriends
//
//  Created by Nikolay Volosatov on 11/22/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import SwiftUI

final class Storage: ObservableObject {
    private static let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!

    let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func load() {
        URLSession.shared.dataTask(with: Self.url) { data, response, error in
            guard let data = data else {
                fatalError("Failed to load users")
            }
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let users = try decoder.decode([UserModel].self, from: data)
                DispatchQueue.main.async {
                    var newUsers: [UUID:User] = [:]
                    for user in users {
                        newUsers[user.id] = self.addUser(user)
                    }
                    for user in users {
                        self.addFriends(for: user, newUsers: newUsers)
                    }

                    try? self.context.save()

                    for user in users {
                        self.loadAvatar(for: user)
                    }
                }
            }
            catch {
                fatalError("Failed to deserialize users: \(error)")
            }
        }.resume()
    }

    private func addUser(_ user: UserModel) -> User {
        let managedUser = User(context: context)
        managedUser.id = user.id
        managedUser.registered = user.registered
        managedUser.isActive = user.isActive
        managedUser.name = user.name
        managedUser.age = Int16(user.age)
        managedUser.company = user.company
        managedUser.about = user.about
        managedUser.email = user.email
        managedUser.address = user.address

        for tag in user.tags {
            let managedTag = Tag(context: context)
            managedTag.name = tag
            managedUser.addToTags(managedTag)
        }

        return managedUser
    }

    private func addFriends(for user: UserModel, newUsers: [UUID:User]) {
        for friend in user.friends {
            let managedFriend = Friend(context: context)
            managedFriend.owner = newUsers[user.id]
            managedFriend.target = newUsers[friend.id]
        }
    }

    private func loadAvatar(for user: UserModel) {
        let url = URL(string: "https://api.adorable.io/avatars/500/\(user.email).png")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                return
            }
            guard UIImage(data: data) != nil else {
                return
            }
            DispatchQueue.main.async {
                let request = NSFetchRequest<User>(entityName: "User")
                request.predicate = NSPredicate(format: "id = %@", argumentArray: [user.id])
                guard let results = try? self.context.fetch(request) else {
                    return
                }
                guard let managedUser = results.first else {
                    return
                }
                managedUser.avatar = data
                try? self.context.save()
            }
        }.resume()
    }
}

extension Storage {
    struct FriendModel: Codable, Identifiable {
        let id: UUID
        let name: String
    }

    struct UserModel: Codable {
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

        let friends: [FriendModel]
    }
}

extension Storage {
    static var mock: Storage {
        Storage(context: NSPersistentContainer(name: "WeFriends").viewContext)
    }
    var userMock: User {
        User(context: context)
    }
}
