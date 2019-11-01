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
                    VStack(spacing: 0) {
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
                                Image(systemName: "delete.left.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.yellow)
                            }
                        }
                    }
                    Button(action: self.complete) {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 70))
                            .foregroundColor(.green)
                            .shadow(radius: 5.0)
                    }
                }
            }
        }
        .frame(width: 400, height: 600)
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
