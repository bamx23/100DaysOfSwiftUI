//
//  ContentView.swift
//  Instafilter
//
//  Created by Nikolay Volosatov on 11/24/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @State private var inputImage: UIImage?
    @State private var image: Image?
    @State private var showingImagePicker = false

    func loadImage() {
        guard let inputImage = inputImage else {
            return
        }
        image = Image(uiImage: inputImage)
    }

    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()

            Button("Select Image") {
                self.showingImagePicker = true
            }
            Button("Save") {
                guard let image = self.inputImage else {
                    return
                }
                ImageSaver.shared.saveImageToAlbum(image)
            }
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
