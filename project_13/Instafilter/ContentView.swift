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
    static let defaultFilter = Filter.sepiaTone()

    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    @State private var image: Image?
    @State private var currentFilter = Self.defaultFilter.ciFilter()
    @State private var currentFilterName = Self.defaultFilter.name
    @State private var filterOptions: [FilterOption:Double] = [:]

    @State private var alertTitle = ""
    @State private var alertMessage = ""

    @State private var showingImagePicker = false
    @State private var showingFilterSheet = false
    @State private var showingAlert = false

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
        guard inputImage != nil else { return }

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

    func setFilter(_ filter: Filter) {
        withAnimation {
            currentFilterName = filter.name
            currentFilter = filter.ciFilter()
        }
        loadImage()
    }

    func saveImage() {
        guard let processedImage = self.processedImage else {
            return
        }
        ImageSaver.shared.saveImageToAlbum(processedImage) { error in
            if let error = error {
                self.alertTitle = "Failed to save image"
                self.alertMessage = error.localizedDescription
            } else {
                self.alertTitle = "Image saved"
                self.alertMessage = ""
            }
            self.showingAlert = true
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
                    Button(currentFilterName) {
                        self.showingFilterSheet = true
                    }
                    .animation(nil)

                    Spacer()

                    Button("Save") {
                        self.saveImage()
                    }
                    .disabled(processedImage == nil)
                }
            }
            .padding([.horizontal, .bottom])
            .navigationBarTitle("Instafilter")
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage)
        }
        .actionSheet(isPresented: $showingFilterSheet) {
            ActionSheet(title: Text("Select a filter"), buttons:
                Filter.allFilters.map { filter in
                    .default(Text(filter.name)) { self.setFilter(filter) }
                } + [.cancel()]
            )
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(self.alertTitle), message: Text(self.alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
