//
//  ContentView.swift
//  BucketList
//
//  Created by Nikolay Volosatov on 12/1/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI
import LocalAuthentication

struct ContentView: View {

    @State private var isUnlocked = false

    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

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
                        self.alertTitle = "Failed to authentificate"
                        self.alertMessage = authenticationError?.localizedDescription ?? ""
                        self.showingAlert = true
                    }
                }
            }
        } else {
            self.alertTitle = "No FaceID/TouchID"
            self.alertMessage = "Use newer device for this app, please"
            self.showingAlert = true
        }
    }

    var body: some View {
        Group {
            if self.isUnlocked {
                ProtectedView()
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
        .onAppear(perform: authenticate)
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(self.alertTitle),
                  message: Text(self.alertMessage),
                  dismissButton: .default(Text("OK")))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
