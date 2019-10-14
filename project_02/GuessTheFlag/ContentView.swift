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
    @State private var choosenAnswer = 0

    @State private var score = 0
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                ForEach(0..<3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        Image(self.countries[number])
                            .renderingMode(.original)
                            .clipShape(Capsule(style: .continuous))
                            .overlay(Capsule(style: .continuous)
                                .stroke(self.strokeColorForFlag(number), lineWidth: 2))
                            .shadow(color: .black, radius: 2)
                    }
                }
                VStack {
                    Text("Score")
                        .foregroundColor(.white)
                    Text("\(score)")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle),
                  message: Text(scoreMessage),
                  dismissButton: .default(Text("OK")) {
                    self.askQuestion()
                })
        }
    }

    func strokeColorForFlag(_ number: Int) -> Color {
        if showingScore {
            if number == correctAnswer {
                return .green
            }
            if number == choosenAnswer {
                return .red
            }
        }
        return .black
    }

    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 30
            scoreMessage = "Your score is \(score)"
        } else {
            scoreTitle = "Wrong"
            score -= 10
            scoreMessage = "That’s the flag of \(countries[number])\nYour score is \(score)"
        }

        choosenAnswer = number
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
