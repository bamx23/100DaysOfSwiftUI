//
//  Storage.swift
//  WeFriends
//
//  Created by Nikolay Volosatov on 11/22/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import Foundation
import UIKit

final class Storage: ObservableObject {
    private static let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!

    @Published var users: [User] = []
    @Published var avatars: [User.ID:UIImage] = [:]

    func load() {
        URLSession.shared.dataTask(with: Self.url) { data, response, error in
            guard let data = data else {
                fatalError("Failed to load users")
            }
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let users = try decoder.decode([User].self, from: data)
                for user in users {
                    self.loadAvatar(for: user)
                }
                DispatchQueue.main.async {
                    self.users = users
                }
            }
            catch {
                fatalError("Failed to deserialize users: \(error)")
            }
        }.resume()
    }

    private func loadAvatar(for user: User) {
        let url = URL(string: "https://api.adorable.io/avatars/500/\(user.email).png")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                return
            }
            guard let image = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                self.avatars[user.id] = image
            }
        }.resume()
    }
}
