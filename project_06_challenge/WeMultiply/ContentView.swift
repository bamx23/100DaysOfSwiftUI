//
//  ContentView.swift
//  WeMultiply
//
//  Created by Nikolay Volosatov on 10/28/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI


struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint

    func body(content: Content) -> some View {
        content.rotationEffect(.degrees(amount), anchor: anchor).clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
        )
    }
}

struct ContentView: View {

    @State private var showSettings = true
    @State private var upTo = 10
    @State private var maxQuestionsCount = 5

    @State private var questions: [Question]!
    @State private var questionIndex = 0
    @State private var answersCorrect: [Bool] = []

    @State private var score = 0
    @State var complete = false

    var question: Question { questions[questionIndex] }
    var questionsCount: Int { min(maxQuestionsCount, upTo * upTo) }

    func start() {
        questions = (0..<questionsCount).map { _ in
            let left = Int.random(in: 1...upTo)
            let right = Int.random(in: 1...upTo)
            let minOption = max(left * right - 10, 1)
            let maxOption = minOption + 20
            let options = ((0..<3).map { _ in
                Int.random(in: minOption...maxOption)
            } + [left * right]).shuffled()
            return Question(leftNumber: left, rightNumber: right, options: options)
        }
        questionIndex = 0
        withAnimation {
            self.showSettings = false
            self.complete = false
            self.score = 0
            self.answersCorrect = []
        }
    }

    func processAnswer(answer: Int) {
        let correct = (question.leftNumber * question.rightNumber) == answer

        score += correct ? 1: -1
        answersCorrect.append(correct)
        withAnimation {
            if questionIndex < questions.count - 1 {
                questionIndex += 1
            } else {
                complete = true
            }
        }
    }

    var settingsView: SettingsView {
        SettingsView { upTo, count in
            self.upTo = upTo
            self.maxQuestionsCount = count
            self.start()
        }
    }

    var body: some View {
        VStack {
            if showSettings {
                settingsView
            } else {
                ZStack {
                    VStack {
                        if questionIndex % 2 == 0 {
                            QuestionViewA(view: QuestionView(question: question, action: processAnswer))
                        } else {
                            QuestionViewB(view: QuestionView(question: question, action: processAnswer))
                        }
                        VStack {
                            Text("Score")
                                .font(.caption)
                            Text("\(score)")
                                .font(.largeTitle)
                            DotsView(count: questionsCount, current: questionIndex, correct: answersCorrect)
                        }
                    }
                    .blur(radius: complete ? 10 : 0)
                    .disabled(complete)

                    CompletionView(score: score,
                                   restartAction: self.start,
                                   settingsAction: { self.showSettings = true })
                        .opacity(complete ? 1 : 0)
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
