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

extension Int {
    var digits: [Int] {
        if self == 0 {
            return [0]
        }
        var result = [Int]()
        var x = self
        while x != 0 {
            result.append(x % 10)
            x /= 10
        }
        return result.reversed()
    }
}

struct QuestionView: View {
    let question: Question
    let option: Binding<Int>
    let action: () -> Void

    @State private var value = 0

    var expectedAnswer: Int { question.leftNumber * question.rightNumber }

    private func addDigit(digit: Int) {
        withAnimation {
            value = value * 10 + digit
        }
    }

    private func removeDigit() {
        withAnimation {
            value /= 10
        }
    }

    private func digitButton(_ digit: Int) -> some View {
        let enabled = (value.digits.count < expectedAnswer.digits.count) || (value == 0)
        return Button(action: { self.addDigit(digit: digit) }) {
            Text("\(digit)")
                .font(.largeTitle)
                .padding()
                .background(enabled ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .clipShape(Circle())
        }
        .disabled(!enabled)
    }

    private var valueView: some View {
        let valueDigits = value.digits
        return HStack {
            ForEach(0..<expectedAnswer.digits.count) { index in
                Text((index < valueDigits.count) && (self.value != 0) ? "\(valueDigits[index])" : "?")
                    .padding()
                    .font(Font.largeTitle)
                    .background(Color.green)
                    .clipShape(Circle())
                    .animation(.spring(response: 1, dampingFraction: 0.1, blendDuration: 0.1))
            }
        }
    }

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .yellow, .red]), startPoint: .top, endPoint: .bottom)
            VStack {
                Text("\(question.leftNumber) x \(question.rightNumber) = ?")
                valueView
                VStack {
                    ForEach(0..<3) { row in
                        HStack {
                            ForEach(0..<3) { col in
                                self.digitButton(row * 3 + col + 1)
                            }
                        }
                    }
                    HStack {
                        digitButton(0)
                        Button(action: self.removeDigit) {
                            Text("<")
                                .font(.largeTitle)
                                .padding()
                                .background(Color.yellow)
                                .foregroundColor(.black)
                                .clipShape(Circle())
                        }
                    }
                }
            }
        }
        .transition(.asymmetric(
            insertion: AnyTransition.move(edge: .trailing).combined(with: .scale),
            removal: AnyTransition.move(edge: .leading).combined(with: .scale)
        ))
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

struct DotsView: View {
    let count: Int
    let current: Int
    let correct: [Bool]

    let maxCount = 10

    private var minIndex: Int { max(min(count - maxCount, current - maxCount / 2), 0) }
    private var maxIndex: Int { min(minIndex + maxCount, count) }
    private var visibleCount: Int { min(count, maxCount) }

    private func dotView(relativeIndex: Int) -> some View {
        let index = relativeIndex + minIndex
        let size = CGFloat(index == current ? 20 : 10)
        var color: Color!
        if index < current {
            if correct[index] {
                color = .green
            } else {
                color = .red
            }
        } else if index == current {
            color = .blue
        } else {
            color = .gray
        }
        return color
            .frame(width: size, height: size)
            .clipShape(Circle())
    }

    private func moreDots(enabled: Bool) -> some View {
        HStack(spacing: 3) {
            ForEach(0..<3) { _ in
                Color.gray
                    .frame(width: 5, height: 5)
                    .clipShape(Circle())
            }
        }
        .opacity(enabled ? 1 : 0)
    }

    var body: some View {
        HStack {
            moreDots(enabled: minIndex != 0)
            ForEach(0..<visibleCount, content: dotView)
            moreDots(enabled: maxIndex != count)
        }
    }
}

struct ContentView: View {

    @State private var showSettings = true
    @State private var upTo = 10
    @State private var maxQuestionsCount = 5

    @State private var questions: [Question]!
    @State private var questionIndex = 0
    @State private var answer = 0
    @State private var answersCorrect: [Bool] = []

    @State private var score = 0

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
        answer = questions[questionIndex].options.randomElement()!
        withAnimation {
            self.showSettings = false
        }
    }

    func processAnswer() {
        let correct = (question.leftNumber * question.rightNumber) == answer

        score += correct ? 1: -1
        answersCorrect.append(correct)
        withAnimation {
            questionIndex += 1
            if questionIndex < questionsCount {
                answer = question.options.randomElement()!
            }
        }
    }

    var settingsView: SettingsView {
        SettingsView(upTo: $upTo, questionsCount: $maxQuestionsCount, action: start)
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
                    DotsView(count: questionsCount, current: questionIndex, correct: answersCorrect)
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
