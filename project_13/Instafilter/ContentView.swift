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
    @State private var processedImage: UIImage?
    @State private var image: Image?
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    @State private var filterOptions: [FilterOption:Double] = [:]

    @State private var showingImagePicker = false
    @State private var showingFilterSheet = false

    let context = CIContext()

    func loadImage() {
        guard let inputImage = inputImage else {
            return
        }

        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }

    func applyProcessing() {
        for option in FilterOption.allCases(forFilter: currentFilter) {
            let value = self.filterOptions[option] ?? option.defaultValue
            currentFilter.setValue(value, forKey: option.key)
        }

        guard let outputImage = currentFilter.outputImage else { return }

        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            processedImage = UIImage(cgImage: cgimg)
            if let processedImage = processedImage {
                image = Image(uiImage: processedImage)
            }
        }
    }

    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }

    func saveImage() {
        guard let processedImage = self.processedImage else {
            return
        }
        ImageSaver.shared.saveImageToAlbum(processedImage) { error in
            if let error = error {
                print("Failed to save image: \(error)")
            } else {
                print("Success")
            }
        }
    }

    func slider(for option: FilterOption) -> some View {
        let optionBinding = Binding<Double>(
            get: {
                self.filterOptions[option] ?? option.defaultValue
            },
            set: {
                self.filterOptions[option] = $0
                self.applyProcessing()
            }
        )

        return HStack {
            Text(option.name)
            Slider(value: optionBinding, in: option.range)
        }.id(option.id)
    }

    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.secondary)

                    if image != nil {
                        image?
                            .resizable()
                            .scaledToFit()
                    } else {
                        Text("Tap to select a picture")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }
                .onTapGesture {
                    self.showingImagePicker = true
                }

                ForEach(FilterOption.allCases(forFilter: currentFilter)) { option in
                    self.slider(for: option)
                        .padding(.vertical)
                }

                HStack {
                    Button("Change Filter") {
                        self.showingFilterSheet = true
                    }

                    Spacer()

                    Button("Save") {
                        self.saveImage()
                    }
                }
            }
            .padding([.horizontal, .bottom])
            .navigationBarTitle("Instafilter")
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage)
        }
        .actionSheet(isPresented: $showingFilterSheet) {
            ActionSheet(title: Text("Select a filter"), buttons: [
                .default(Text("Crystallize")) { self.setFilter(CIFilter.crystallize()) },
                .default(Text("Edges")) { self.setFilter(CIFilter.edges()) },
                .default(Text("Gaussian Blur")) { self.setFilter(CIFilter.gaussianBlur()) },
                .default(Text("Pixellate")) { self.setFilter(CIFilter.pixellate()) },
                .default(Text("Sepia Tone")) { self.setFilter(CIFilter.sepiaTone()) },
                .default(Text("Unsharp Mask")) { self.setFilter(CIFilter.unsharpMask()) },
                .default(Text("Vignette")) { self.setFilter(CIFilter.vignette()) },
                .cancel()
            ])
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
