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

struct ContentView: View {
    @State private var appChoice = Move.random()
    @State private var shouldWin = Bool.random()
    @State private var score = 0

    func makeMove(_ move: Move) {
        let won = shouldWin ? move == appChoice.enemy() : appChoice == move.enemy()
        score += won ? 1 : -1
        appChoice = Move.random()
        shouldWin = Bool.random()
    }

    var body: some View {
        VStack {
            Text("Score")
            Text("\(score)")
            Text("\(appChoice.name())")
            Text("\(shouldWin ? "Win" : "Lose")")
            HStack {
                ForEach(Move.all, id: \.self) { move in
                    Button(action: { self.makeMove(move) }) {
                        Text(move.name())
                    }
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
