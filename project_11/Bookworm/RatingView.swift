//
//  RatingView.swift
//  Bookworm
//
//  Created by Nikolay Volosatov on 11/16/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating: Int

    var label = ""

    var maximumRating = 5

    var offImage: Image?
    var onImage = Image(systemName: "star.fill")

    var offColor = Color.gray
    var onColor = Color.yellow

    func image(for number: Int) -> Image {
        number > rating ? (offImage ?? onImage) : onImage
    }

    var body: some View {
        HStack {
            if label.isEmpty == false {
                Text(label)
                Spacer()
            }
            ForEach(1..<maximumRating + 1) { number in
                self.image(for: number)
                    .foregroundColor(number > self.rating ? self.offColor : self.onColor)
                    .onTapGesture {
                        self.rating = number
                    }
            }
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: .constant(3))
    }
}
