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

    @State var nameFilter = ""

    var filteredUsers: [User] { storage.users.filter {
        nameFilter == "" || $0.name.lowercased().contains(nameFilter.lowercased()) }
    }

    var body: some View {
        NavigationView {
            List {
                TextField("Search", text: $nameFilter.animation())
                ForEach(filteredUsers) { user in
                    NavigationLink(destination: DetailView(user: user)) {
                        UserCardView(user: user)
                    }
                }
            }
            .navigationBarTitle("WeFriends")
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
