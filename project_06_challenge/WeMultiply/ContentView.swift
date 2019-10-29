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

struct SettingsView: View {
    static let upToOptionsCount = 12
    static let questionsCountOptions = [5, 10, 20, Int.max]

    let upTo: Binding<Int>
    let questionsCount: Binding<Int>
    let action: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .yellow, .red]), startPoint: .top, endPoint: .bottom)
            VStack {
                Picker(selection: upTo, label: Text("Up to...")) {
                    ForEach(0..<Self.upToOptionsCount) { num in
                        Text("\(num + 1)")
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                Picker(selection: questionsCount, label: Text("Questions count")) {
                    ForEach(Self.questionsCountOptions, id: \.self) { num in
                        Text(num == Int.max ? "All" : "\(num)")
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                Button(action: action) {
                    Text("Go")
                        .font(.largeTitle)
                }
            }
        }
        .transition(.pivot)
    }
}

struct Question {
    let leftNumber: Int
    let rightNumber: Int
    let options: [Int]
}

struct QuestionView: View {
    let question: Question
    let option: Binding<Int>
    let action: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .yellow, .red]), startPoint: .top, endPoint: .bottom)
            VStack {
                Text("\(question.leftNumber) x \(question.rightNumber) = ?")
                Picker(selection: option, label: Text("Questions count")) {
                    ForEach(self.question.options, id: \.self) { num in
                        Text("\(num)")
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                Button(action: action) {
                    Text("Go")
                        .font(.largeTitle)
                }
            }
        }
        .transition(.pivot)
    }
}

struct CompletionView: View {
    let score: Int
    let settingsView: SettingsView

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .yellow, .red]), startPoint: .top, endPoint: .bottom)
            VStack {
                Text("Result")
                    .font(.caption)
                Text("\(score)")
                    .font(.largeTitle)
                settingsView
            }
        }
    }
}

struct ContentView: View {

    @State private var showSettings = true
    @State private var upTo = 10
    @State private var questionsCount = 5

    @State private var questions: [Question]!
    @State private var questionIndex = 0
    @State private var answer = 0

    @State private var score = 0

    var question: Question { questions[questionIndex] }

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
        answer = questions[questionIndex].options.randomElement()!
        withAnimation {
            self.showSettings = false
        }
    }

    func processAnswer() {
        let correct = (question.leftNumber * question.rightNumber) == answer

        score += correct ? 1: -1
        withAnimation {
            questionIndex += 1
            if questionIndex < questionsCount {
                answer = question.options.randomElement()!
            }
        }
    }

    var settingsView: SettingsView {
        SettingsView(upTo: $upTo, questionsCount: $questionsCount, action: start)
    }

    var body: some View {
        VStack {
            if showSettings {
                settingsView
            } else if questionIndex < questionsCount {
                if questionIndex % 2 == 0 {
                    QuestionView(question: question, option: $answer, action: processAnswer)
                } else {
                    QuestionView(question: question, option: $answer, action: processAnswer)
                }
                VStack {
                    Text("Score")
                        .font(.caption)
                    Text("\(score)")
                        .font(.largeTitle)
                    Text("\(questionIndex + 1) / \(questionsCount)")
                }
            } else {
                CompletionView(score: score, settingsView: settingsView)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
