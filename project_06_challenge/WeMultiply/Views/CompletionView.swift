//
//  CompletionView.swift
//  WeMultiply
//
//  Created by Nikolay Volosatov on 10/31/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

struct CompletionView: View {
    let score: Int

    let restartAction: () -> Void
    let settingsAction: () -> Void

    var body: some View {
        ZStack {
            Color.blue
                .frame(width: 300, height: 400)
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
            VStack {
                Text("Result")
                    .font(Font.system(size: 30))
                Text("\(score)")
                    .font(Font.system(size: 50).bold())
                HStack(spacing: 20) {
                    Button(action: restartAction) {
                        Image(systemName: "gobackward")
                            .font(.system(size: 70))
                    }
                    Button(action: settingsAction) {
                        Image(systemName: "gear")
                            .font(.system(size: 70))
                    }
                }
            }
            .foregroundColor(.white)
        }
        .shadow(radius: 10)
    }
}
