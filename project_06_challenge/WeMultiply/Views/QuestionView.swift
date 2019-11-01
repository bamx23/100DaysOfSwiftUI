//
//  QuestionView.swift
//  WeMultiply
//
//  Created by Nikolay Volosatov on 10/31/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

struct Question {
    let leftNumber: Int
    let rightNumber: Int
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
    let action: (Int) -> Void

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

    private func complete() {
        self.action(value)
    }

    private func digitButton(_ digit: Int) -> some View {
        let enabled = (value.digits.count < expectedAnswer.digits.count) || (value == 0)
        return Button(action: { self.addDigit(digit: digit) }) {
            CircleImageView(number: digit, size: 60)
                .foregroundColor(enabled ? Color.blue : Color.gray)
                .padding()
        }
        .disabled(!enabled)
    }

    private var valueView: some View {
        let valueDigits = value.digits
        return HStack {
            ForEach(0..<expectedAnswer.digits.count) { index in
                CircleImageView(name: (index < valueDigits.count) && (self.value != 0) ? "\(valueDigits[index])" : "questionmark", size: 50)
                    .foregroundColor(.green)
            }
        }
    }

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .yellow, .red]), startPoint: .top, endPoint: .bottom)
            VStack {
                Text("\(question.leftNumber) x \(question.rightNumber) = ?")
                    .font(.system(size: 50))
                valueView
                VStack {
                    VStack(spacing: 0) {
                        ForEach(0..<3) { row in
                            HStack(spacing: 0) {
                                ForEach(0..<3) { col in
                                    self.digitButton(row * 3 + col + 1)
                                }
                            }
                        }
                        HStack {
                            digitButton(0)
                            Button(action: self.removeDigit) {
                                Image(systemName: "delete.left.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.yellow)
                                    .shadow(radius: 10)
                            }
                        }
                    }
                    Button(action: self.complete) {
                        CircleImageView(name: "play", size: 70)
                            .foregroundColor(.green)
                            .padding()
                    }
                }
            }
        }
        .padding([.horizontal], -50)
        .frame(maxHeight: 700)
        .clipShape(RoundedRectangle(cornerRadius: 10.0))
        .transition(.asymmetric(
            insertion: AnyTransition.move(edge: .trailing).combined(with: .scale),
            removal: AnyTransition.move(edge: .leading).combined(with: .scale)
            ))
    }
}

struct QuestionViewA: View {
    let view: QuestionView

    var body: some View {
        view
    }
}

struct QuestionViewB: View {
    let view: QuestionView

    var body: some View {
        view
    }
}
