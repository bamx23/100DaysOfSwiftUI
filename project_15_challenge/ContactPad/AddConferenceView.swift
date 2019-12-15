//
//  AddConferenceView.swift
//  ContactPad
//
//  Created by Nikolay Volosatov on 12/15/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

struct AddConferenceView: View {
    @Environment(\.presentationMode) var presentationMode

    let callback: (Conference) -> Void

    @State private var name = ""
    @State private var startDate = Date()
    @State private var endDate = Date()

    var invalidationMessage: String? {
        if name.count == 0 {
            return "Name of the conference is too short"
        }
        if endDate < startDate {
            return "End date should be greater or equal to start date"
        }
        return nil
    }

    func save() {
        let conference = Conference(id: UUID(), name: name, startDate: startDate, endDate: endDate)
        withAnimation {
            callback(conference)
        }
        presentationMode.wrappedValue.dismiss()
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name", text: $name)
                    DatePicker(selection: $startDate, displayedComponents: .date) {
                        Text("Start date")
                    }
                    DatePicker(selection: $endDate, displayedComponents: .date) {
                        Text("Start date")
                    }
                }

                Section {
                    if (invalidationMessage != nil) {
                        Text(invalidationMessage!)
                            .font(.headline)
                            .foregroundColor(.red)
                    }
                    Button(action: save) {
                        Text("Add")
                    }
                    .disabled(invalidationMessage != nil)
                }
            }
            .navigationBarTitle(Text("New Conference"))
        }
    }
}

struct AddConferenceView_Previews: PreviewProvider {
    static var previews: some View {
        AddConferenceView { conference in
        }
    }
}
