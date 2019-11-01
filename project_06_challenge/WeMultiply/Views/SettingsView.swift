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
            Image(systemName: "\(number).circle.fill")
                .font(.system(size: 60))
                .background(Color.white
                    .frame(width: 60, height: 60)
                    .clipShape(Circle()))
                .foregroundColor(color)
                .padding()
        }
    }
}

private struct AllView: View {
    let selected: Int
    let action: (Int) -> Void

    private let number = Int.max

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
            Text("ALL")
                .font(.system(size: 40))
                .padding(7)
                .background(color)
                .foregroundColor(.white)
                .clipShape(Circle())
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
                        NumberView(number: row * 4 + col + 1, selected: self.selectedUpTo) { num in
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
            ForEach(0..<Self.questionsCountOptions.count) { idx in
                NumberView(number: Self.questionsCountOptions[idx], selected: self.selectedCount) { num in
                    withAnimation {
                        self.selectedCount = num
                    }
                }
            }
            AllView(selected: self.selectedCount) { num in
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

