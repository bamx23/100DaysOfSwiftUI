//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Nikolay Volosatov on 10/16/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension View {
    func titleStyle() -> some View {
        self.modifier(Title())
    }
}

struct Watermark: ViewModifier {
    var text: String

    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing) {
            content
            Text(text)
                .font(.caption)
                .foregroundColor(.white)
                .padding(5)
                .background(Color.black.blur(radius: 2))
        }
    }
}

extension View {
    func watermarked(with text: String) -> some View {
        self.modifier(Watermark(text: text))
    }
}

struct CapsuleText: View {
    var text: String

    var body: some View {
        Text(text)
            .titleStyle()
    }
}

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content

    var body: some View {
        VStack {
            ForEach(0 ..< self.rows) { row in
                HStack {
                    ForEach(0 ..< self.columns) { column in
                        self.content(row, column)
                    }
                }
            }
        }
    }
}

struct LargetTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.blue)
    }
}

extension View {
    func largeTitle() -> some View {
        self.modifier(LargetTitleModifier())
    }
}

struct ContentView: View {
    @State private var useRedText = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Title")
                .largeTitle()
            CapsuleText(text: "First")
                .foregroundColor(.white)
            CapsuleText(text: "Watermarked")
                .foregroundColor(.yellow)
                .watermarked(with: "bamx23")
            GridStack(rows: 3, columns: 3) { r, c in
                HStack {
                    Image(systemName: "\(r * 3 + c).circle")
                    Text("\(r)x\(c)")
                        .font(.custom("Courier New", size: 10))
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
