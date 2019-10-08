//
//  ContentView.swift
//  WeSplit
//
//  Created by Nikolay Volosatov on 10/9/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let students = ["Harry", "Hermione", "Ron"]

    @State private var tapCount = 0
    @State private var name = ""
    @State private var selectedStudent = "Harry"

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("Your name is \(name)")
                    Button("Tap Count: \(tapCount)") {
                        self.tapCount += 1
                    }
                    TextField("Enter your name", text: $name)
                }
                Section {
                    Picker("Select your student", selection: $selectedStudent) {
                        ForEach(0 ..< students.count) {
                            Text(self.students[$0])
                        }
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
