//
//  ContentView.swift
//  WeFriends
//
//  Created by Nikolay Volosatov on 11/22/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var storage: Storage

    @FetchRequest(entity: User.entity(), sortDescriptors: []) var users: FetchedResults<User>

    @State var nameFilter = ""

    var body: some View {
        NavigationView {
            List {
                TextField("Search", text: $nameFilter.animation())
                FilteredList(sort: [.ascending(\.name)], filter: (\.name, .contains(nameFilter))) { (user: User) in
                    NavigationLink(destination: DetailView(user: user)) {
                        UserCardView(user: user)
                    }
                }
            }
            .navigationBarTitle("WeFriends")
        }
        .onAppear {
            if (self.users.count == 0) {
                self.storage.load()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Storage.mock)
    }
}
