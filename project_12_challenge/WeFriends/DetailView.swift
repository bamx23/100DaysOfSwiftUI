//
//  DetailView.swift
//  WeFriends
//
//  Created by Nikolay Volosatov on 11/22/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    let user: User
    
    var body: some View {
        Text("Hello, World!")
    }
}

struct DetailView_Previews: PreviewProvider {
    static let user = User(
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
    static var previews: some View {
        DetailView(user: user)
    }
}
