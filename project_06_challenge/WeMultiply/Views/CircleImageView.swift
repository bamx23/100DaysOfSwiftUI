//
//  NumberView.swift
//  WeMultiply
//
//  Created by Nikolay Volosatov on 11/1/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

struct CircleImageView: View {
    let name: String?
    let number: Int?
    let size: CGFloat

    init(name: String, size: CGFloat) {
        self.number = nil
        self.name = name
        self.size = size
    }

    init(number: Int, size: CGFloat) {
        self.number = number
        self.name = nil
        self.size = size
    }

    var body: some View {
        Image(systemName: "\(name ?? String(number ?? 0)).circle.fill")
            .font(.system(size: size))
            .background(Color.white
                .frame(width: size - 1, height: size - 1)
                .clipShape(Circle()))
    }
}
