//
//  ContentView.swift
//  Accessibility
//
//  Created by Nikolay Volosatov on 12/15/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let pictures = [
        "ales-krivec-15949",
        "galina-n-189483",
        "kevin-horstmann-141705",
        "nicolas-tissot-335096"
    ]

    let labels = [
        "Tulips",
        "Frozen tree buds",
        "Sunflowers",
        "Fireworks",
    ]

    @State private var selectedPicture = Int.random(in: 0...3)
    @State private var estimate = 25.0
    @State private var rating = 3

    var body: some View {
        VStack {
            Image(pictures[selectedPicture])
                .resizable()
                .scaledToFit()
                .accessibility(label: Text(labels[selectedPicture]))
                .accessibility(addTraits: .isButton)
                .accessibility(removeTraits: .isImage)
                .onTapGesture {
                    self.selectedPicture = Int.random(in: 0...3)
                }


            VStack {
                Text("Your score is")
                Text("1000")
                    .font(.title)
            }
            .accessibilityElement(children: .ignore)
            .accessibility(label: Text("Your score is 1000"))


            Slider(value: $estimate, in: 0...50)
                .padding()
                .accessibility(value: Text("\(Int(estimate))"))


            Stepper("Rate our service: \(rating)/5", value: $rating, in: 1...5)
                .accessibility(label: Text("Rate our service"))
                .accessibility(value: Text("\(rating) out of 5"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
