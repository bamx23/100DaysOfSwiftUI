//
//  ContentView.swift
//  Animations
//
//  Created by Nikolay Volosatov on 10/25/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let letters = Array("Hello SwiftUI")
    @State private var enabled = false
    @State private var draggin = false
    @State private var dragAmount = CGSize.zero

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<letters.count) { num in
                Text(String(self.letters[num]))
                    .padding(5)
                    .font(.title)
                    .background(self.enabled ? Color.blue : Color.red)
                    .clipShape(RoundedRectangle(cornerRadius: self.draggin ? 20 : 0))
                    .offset(self.dragAmount)
                    .animation(Animation.default.delay(Double(num) / 20))
            }
        }
        .gesture(
            DragGesture()
                .onChanged {
                    self.dragAmount = $0.translation
                    self.draggin = true
                }
                .onEnded { _ in
                    self.dragAmount = .zero
                    self.enabled.toggle()
                    self.draggin = false
            }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
