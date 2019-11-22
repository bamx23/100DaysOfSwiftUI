//
//  ContentView.swift
//  WeFriends
//
//  Created by Nikolay Volosatov on 11/22/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var storage: Storage

    func avatar(for user: User) -> Image {
        if let avatar = storage.avatars[user.id] {
            return Image(uiImage: avatar)
        } else {
            return Image(systemName: "person.circle.fill")
        }
    }

    var body: some View {
        List(storage.users) { user in
            HStack {
                self.avatar(for: user)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                Text(user.name)
            }
        }
        .onAppear(perform: storage.load)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Storage())
    }
}
