//
//  ContentView.swift
//  WeSplit
//
//  Created by Nikolay Volosatov on 10/9/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var tapCount = 0

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("Hello World")
                    Button("Tap Count: \(tapCount)") {
                        self.tapCount += 1
                    }
                }
            }
            .navigationBarTitle(Text("SwiftUI"), displayMode: .inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
