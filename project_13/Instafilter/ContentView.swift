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
    @State private var image: Image?

    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
        }
        .onAppear(perform: loadImage)
    }

    func loadImage() {
        guard let inputImage = UIImage(named: "Example") else {
            fatalError("Image not found")
        }
        let beginImage = CIImage(image: inputImage)
        let context = CIContext()

        let sepiaFilter = CIFilter.sepiaTone()
        sepiaFilter.inputImage = beginImage
        sepiaFilter.intensity = 1.0

        let crystalizeFilter = CIFilter.crystallize()
//        crystalizeFilter.inputImage = sepiaFilter.outputImage
        crystalizeFilter.setValue(sepiaFilter.outputImage, forKey: kCIInputImageKey)
        crystalizeFilter.radius = 20

        guard let outputImage = crystalizeFilter.outputImage else {
            return
        }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return
        }
        image = Image(uiImage: UIImage(cgImage: cgImage))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
