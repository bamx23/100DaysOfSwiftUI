//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Nikolay Volosatov on 10/13/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.red.edgesIgnoringSafeArea(.all)
            Text("Your content")
                .padding()
                .background(Color.secondary.colorInvert())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
