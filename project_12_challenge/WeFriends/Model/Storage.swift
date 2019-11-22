//
//  Storage.swift
//  WeFriends
//
//  Created by Nikolay Volosatov on 11/22/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import Foundation

final class Storage: ObservableObject {
    private static let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!

    @Published var users: [User] = []

    func load() {
        URLSession.shared.dataTask(with: Self.url) { data, response, error in
            guard let data = data else {
                fatalError("Failed to load users")
            }
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let users = try decoder.decode([User].self, from: data)
                DispatchQueue.main.async {
                    self.users = users
                }
            }
            catch {
                fatalError("Failed to deserialize users: \(error)")
            }
        }.resume()
    }
}
