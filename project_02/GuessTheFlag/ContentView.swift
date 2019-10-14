//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Nikolay Volosatov on 10/13/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = [
        "Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"
    ].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)

    @State private var showingScore = false
    @State private var scoreTitle = ""

    var body: some View {
        ZStack {
            Color.blue.edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .font(.headline)
                        .foregroundColor(.white)
                }
                ForEach(0..<3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        Image(self.countries[number])
                            .renderingMode(.original)
                    }
                }
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text("Score"), message: Text("100"), dismissButton: .default(Text("OK")) {
                self.askQuestion()
            })
        }
    }

    func flagTapped(_ number: Int) {
        scoreTitle = number == correctAnswer ? "Correct" : "Wrong"
        showingScore = true
    }

    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
