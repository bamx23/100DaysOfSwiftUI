//
//  AddressBook.swift
//  CupcakeCorner
//
//  Created by Nikolay Volosatov on 11/13/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import Foundation

final class AddressBook: ObservableObject {
    private static let list_key = "address_book_list"

    @Published var list: [Address] = [] {
        didSet {
            guard let data = try? JSONEncoder().encode(list) else {
                return
            }
            UserDefaults.standard.set(data, forKey: Self.list_key)
        }
    }

    init() {
        if let data = UserDefaults.standard.data(forKey: Self.list_key) {
            if let list = try? JSONDecoder().decode([Address].self, from: data) {
                self.list = list
                return
            }
        }
        self.list = []
    }

}
