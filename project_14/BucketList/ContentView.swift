//
//  ContentView.swift
//  BucketList
//
//  Created by Nikolay Volosatov on 12/1/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI
import LocalAuthentication
import MapKit

struct ContentView: View {

    @State private var isUnlocked = true // FIXME
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var locations = [CodableMKPointAnnotation]()

    @State private var showingPlaceDetails = false
    @State private var selectedPlace: MKPointAnnotation?

    @State private var showingEditScreen = false

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func loadData() {
        let filename = getDocumentsDirectory().appendingPathComponent("SavedPlaces")

        do {
            let data = try Data(contentsOf: filename)
            locations = try JSONDecoder().decode([CodableMKPointAnnotation].self, from: data)
        } catch {
            print("Unable to load saved data.")
        }
    }

    func saveData() {
        do {
            let filename = getDocumentsDirectory().appendingPathComponent("SavedPlaces")
            let data = try JSONEncoder().encode(self.locations)
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
    }

    func authenticate() {
        guard isUnlocked == false else { return }

        let context = LAContext()
        var error: NSError?

        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "We need to unlock your data."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                DispatchQueue.main.async {
                    if success {
                        self.isUnlocked = true
                    } else {
                        // there was a problem
                    }
                }
            }
        } else {
            // no biometrics
        }
    }

    var body: some View {
        Group {
            if self.isUnlocked {
                ZStack {
                    MapView(centerCoordinate: $centerCoordinate,
                            selectedPlace: $selectedPlace,
                            showingPlaceDetails: $showingPlaceDetails,
                            annotations: locations)
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
                                self.locations.append(newLocation)
                                self.selectedPlace = newLocation
                                self.showingEditScreen = true
                            }) {
                                Image(systemName: "plus")
                            }
                            .padding()
                            .background(Color.black.opacity(0.75))
                            .foregroundColor(.white)
                            .font(.title)
                            .clipShape(Circle())
                            .padding(.trailing)
                        }
                    }
                }
            } else {
                Button("Unlock Places") {
                    self.authenticate()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
        }
        .onAppear(perform: {
            self.authenticate()
            self.loadData()
        })
        .alert(isPresented: $showingPlaceDetails) {
            Alert(title: Text(selectedPlace?.title ?? "-"),
                  message: Text(selectedPlace?.subtitle ?? "-"),
                  primaryButton: .default(Text("OK")),
                  secondaryButton: .default(Text("Edit")) {
                    self.showingEditScreen = true
                })
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: saveData) {
            if self.selectedPlace != nil {
                EditView(placemark: self.selectedPlace!)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
