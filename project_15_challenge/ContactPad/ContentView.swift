//
//  ContentView.swift
//  ContactPad
//
//  Created by Nikolay Volosatov on 12/15/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var storage: Storage

    var body: some View {
        TabView {
            PeopleView()
                .environmentObject(storage)
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("People")
                }
            ConferencesView()
                .environmentObject(storage)
                .tabItem {
                    Image(systemName: "quote.bubble.fill")
                    Text("Conferences")
                }
        }
        .onAppear(perform: { self.storage.load() })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Storage.sample)
    }
}
