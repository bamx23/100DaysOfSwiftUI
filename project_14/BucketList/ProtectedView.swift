//
//  ProtectedView.swift
//  BucketList
//
//  Created by Nikolay Volosatov on 12/9/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI
import MapKit

struct ProtectedView: View {
    @EnvironmentObject var storage: Storage

    @State private var centerCoordinate = CLLocationCoordinate2D()

    @State private var showingPlaceDetails = false
    @State private var selectedPlace: MKPointAnnotation?

    @State private var showingEditScreen = false

    var body: some View {
        ZStack {
            MapView(centerCoordinate: $centerCoordinate,
                    selectedPlace: $selectedPlace,
                    showingPlaceDetails: $showingPlaceDetails,
                    annotations: storage.locations)
                .edgesIgnoringSafeArea(.all)
            Circle()
                .fill(Color.blue)
                .opacity(0.3)
                .frame(width: 32, height: 32)

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        let newLocation = CodableMKPointAnnotation()
                        newLocation.coordinate = self.centerCoordinate
                        newLocation.title = "Example location"
                        self.storage.locations.append(newLocation)
                        self.selectedPlace = newLocation
                        self.showingEditScreen = true
                    }) {
                        Image(systemName: "plus")
                            .padding()
                            .background(Color.black.opacity(0.75))
                            .foregroundColor(.white)
                            .font(.title)
                            .clipShape(Circle())
                            .padding(.trailing)
                    }
                }
            }
        }
        .alert(isPresented: $showingPlaceDetails) {
            Alert(title: Text(selectedPlace?.title ?? "-"),
                  message: Text(selectedPlace?.subtitle ?? "-"),
                  primaryButton: .default(Text("OK")),
                  secondaryButton: .default(Text("Edit")) {
                    self.showingEditScreen = true
                })
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: storage.saveData) {
            if self.selectedPlace != nil {
                EditView(placemark: self.selectedPlace!)
            }
        }
        .onAppear(perform: storage.loadData)
    }
}

struct ProtectedView_Previews: PreviewProvider {
    static var previews: some View {
        ProtectedView()
    }
}
