//
//  ContentView.swift
//  Moonshot
//
//  Created by Nikolay Volosatov on 11/5/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

struct User: Codable {
    var name: String
    var address: Address
}

struct Address: Codable {
    var street: String
    var city: String
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Button("Decode") {
                    let input = """
                    {
                        "name": "Taylor Swift",
                        "address": {
                            "street": "555, Taylor Swift Avenue",
                            "city": "Nashville"
                        }
                    }
                    """
                    let data = Data(input.utf8)
                    let decoder = JSONDecoder()
                    if let user = try? decoder.decode(User.self, from: data) {
                        print(user.address.street)
                    }
                }
            }
            .navigationBarTitle("SwiftUI")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
