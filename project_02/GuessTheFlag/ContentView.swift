//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Nikolay Volosatov on 10/13/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var showingAlert = false

    var body: some View {
        ZStack {
            AngularGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]), center: .center)
                .edgesIgnoringSafeArea(.all)
            Circle().frame(width: 50, height: 50).foregroundColor(Color.white)
            VStack {
                Text("Your content")
                    .padding()
                    .background(Color.secondary.colorInvert())
                Button(action: { self.showingAlert.toggle() }) {
                    HStack(spacing: 10) {
                        Image(systemName: "pencil")
                        Text("Edit")
                    }
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Hello SwiftUI!"),
                          message: Text("This is some detail message"),
                          dismissButton: .default(Text("OK")))
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
