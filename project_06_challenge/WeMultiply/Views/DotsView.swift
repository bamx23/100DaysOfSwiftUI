//
//  DotsView.swift
//  WeMultiply
//
//  Created by Nikolay Volosatov on 10/31/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

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

