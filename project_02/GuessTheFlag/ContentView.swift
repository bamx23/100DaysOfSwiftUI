//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Nikolay Volosatov on 10/13/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

fileprivate let labels = [
    "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
    "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
    "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
    "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
    "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
    "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
    "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
    "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
    "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
    "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
    "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner",
]

struct FlagView: View {
    let name: String
    let correct: Bool
    let choosen: Bool
    let playerCorrect: Bool
    let enabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(name)
                .renderingMode(.original)
                .opacity((enabled || correct) ? 1.0 : 0.25)
                .overlay(
                    ZStack {
                        Color.red
                            .opacity(correct ? 0.0 : 0.5)
                        Text(name)
                            .font(Font.title.bold())
                            .padding()
                            .scaledToFill()
                            .foregroundColor(.black)
                            .background(Color.white)
                            .opacity(0.75)
                            .clipShape(Capsule())
                    }
                    .opacity((enabled || playerCorrect || (!choosen && !correct)) ? 0.0 : 1.0)
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black, radius: 2)
                .rotation3DEffect(Angle(degrees: (choosen && correct) ? 360.0 : 0.0), axis: (x: 0, y: 1, z: 0))
                .animation(enabled ? nil : Animation.easeOut.delay(0.5))
                .accessibility(label: Text(labels[name, default: "Unknown flag"]))
        }
        .disabled(!enabled)
    }
}

struct ContentView: View {
    @State private var countries = [
        "Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"
    ].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var choosenAnswer: Int?

    @State private var score = 0

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
                    FlagView(name: self.countries[number],
                             correct: self.correctAnswer == number,
                             choosen: self.choosenAnswer == number,
                             playerCorrect: self.choosenAnswer == self.correctAnswer,
                             enabled: self.choosenAnswer == nil) {
                                self.flagTapped(number)
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
    }

    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            score += 30
        } else {
            score -= 10
        }
        choosenAnswer = number
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now().advanced(by: .seconds(2))) {
            self.askQuestion()
        }
    }

    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        choosenAnswer = nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
