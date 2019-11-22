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

    var body: some View {
        List(storage.users) { user in
            Text(user.name)
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
