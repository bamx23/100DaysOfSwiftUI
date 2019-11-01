//
//  SettingsView.swift
//  WeMultiply
//
//  Created by Nikolay Volosatov on 10/31/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

private struct NumberView: View {
    let number: Int
    let name: String
    let selected: Int
    let action: (Int) -> Void

    var body: some View {
        var color: Color!
        if (number < selected) {
            color = .green
        } else if (number == selected) {
            color = .blue
        } else {
            color = .gray
        }
        return Button(action: { self.action(self.number) }) {
            CircleImageView(name: name, size: 60)
                .foregroundColor(color)
                .padding()
        }
    }
}

struct SettingsView: View {
    static let upToOptionsCount = 12
    static let questionsCountOptions = [5, 10, 20]

    let action: (Int, Int) -> Void

    @State private var selectedUpTo = 10
    @State private var selectedCount = 5

    var upToNumbers: some View {
        VStack {
            ForEach(0..<3) { row in
                HStack {
                    ForEach(0..<4) { col in
                        NumberView(number: row * 4 + col + 1, name: "\(row * 4 + col + 1)", selected: self.selectedUpTo) { num in
                            withAnimation {
                                self.selectedUpTo = num
                            }
                        }
                    }
                }
            }
        }
    }

    var sountNumbers: some View {
        HStack(spacing: 0) {
            ForEach(Self.questionsCountOptions, id: \.self) { num in
                NumberView(number: num, name: "\(num)", selected: self.selectedCount) { num in
                    withAnimation {
                        self.selectedCount = num
                    }
                }
            }
            NumberView(number: Int.max, name: "a", selected: self.selectedCount) { num in
                withAnimation {
                    self.selectedCount = num
                }
            }
        }
    }

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .yellow, .red]), startPoint: .top, endPoint: .bottom)
            VStack {
                Text("What numbers do you want to practice?")
                upToNumbers
                Text("How many questions do you want?")
                sountNumbers
                Button(action: { self.action(self.selectedUpTo, self.selectedCount) }) {
                    Text("Go")
                        .font(.largeTitle)
                }
            }
        }
        .transition(.pivot)
    }
}

