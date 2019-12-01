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

    func authenticate() {
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
                MapView()
                    .edgesIgnoringSafeArea(.all)
            } else {
                Text("Locked")
            }
        }
        .onAppear(perform: authenticate)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
