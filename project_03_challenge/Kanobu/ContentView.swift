//
//  ContentView.swift
//  Kanobu
//
//  Created by Nikolay Volosatov on 10/21/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

enum Move {
    case rock
    case paper
    case scissors
}

extension Move {
    func name() -> String {
        switch self {
        case .rock:
            return "Rock"
        case .paper:
            return "Paper"
        case .scissors:
            return "Scissors"
        }
    }

    func enemy() -> Move {
        switch self {
        case .rock:
            return .paper
        case .paper:
            return .scissors
        case .scissors:
            return .rock
        }
    }

    static var all: [Move] { [.rock, .paper, .scissors] }
    static func random() -> Move { all[Int.random(in: 0...2)] }
}

extension View {
    func forMove(_ move: Move) -> some View {
        switch move {
        case .rock:
            return self
                .background(Color.red)
                .foregroundColor(.white)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color.white, lineWidth: 2))
        case .paper:
            return self
                .background(Color.white)
                .foregroundColor(.black)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color.black, lineWidth: 2))
        case .scissors:
            return self
                .background(Color.gray)
                .foregroundColor(.black)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color.black, lineWidth: 2))
        }
    }
}

struct ContentView: View {
    let roundsCount = 10

    @State private var appChoice = Move.random()
    @State private var shouldWin = Bool.random()
    @State private var score = 0
    @State private var roundNumber = 1

    var complete: Bool {
        return roundNumber > roundsCount
    }

    func makeMove(_ move: Move) {
        let won = shouldWin ? move == appChoice.enemy() : appChoice == move.enemy()
        score += won ? 1 : -1
        roundNumber += 1
        if !complete {
            appChoice = Move.random()
            shouldWin = Bool.random()
        }
    }

    func restart() {
        roundNumber = 0
        appChoice = Move.random()
        shouldWin = Bool.random()
    }

    var scoreView: some View {
        VStack {
            Text("Score")
                .font(.caption)
            Text("\(score)")
                .font(.largeTitle)
                .frame(minWidth: 100)
        }
        .background(Color.blue)
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                scoreView

                Spacer()
                Text(appChoice.name())
                    .padding()
                    .padding(.horizontal)
                    .forMove(appChoice)
                Text("\(shouldWin ? "👍 Win" : "👎 Lose")")
                HStack {
                    ForEach(Move.all, id: \.self) { move in
                        Button(action: { self.makeMove(move) }) {
                            Text(move.name())
                        }
                        .padding()
                        .forMove(move)
                    }
                }
                Spacer()
            }
            .blur(radius: complete ? 8 : 0)
            .disabled(complete)

            VStack(spacing: 10) {
                Text("Complete")
                scoreView
                Button(action: restart) {
                    HStack(spacing: 5) {
                        Image(systemName: "arrow.uturn.left.circle")
                        Text("Restart")
                    }
                }
            }
            .padding()
            .background(Color.primary.colorInvert())
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.primary, lineWidth: 2))
            .opacity(complete ? 1 : 0)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
