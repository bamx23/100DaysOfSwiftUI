//
//  ContentView.swift
//  Drawing
//
//  Created by Nikolay Volosatov on 11/7/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Path { path in
            path.move(to: .init(x: 200, y: 100))
            path.addLine(to: .init(x: 100, y: 300))
            path.addLine(to: .init(x: 300, y: 300))
            path.addLine(to: .init(x: 200, y: 100))
        }
        .stroke(Color.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
