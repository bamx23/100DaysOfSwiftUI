//
//  AddPersonView.swift
//  ContactPad
//
//  Created by Nikolay Volosatov on 12/15/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

struct AddPersonView: View {
    @EnvironmentObject var storage: Storage

    @State private var name = ""
    @State private var date = Date()
    @State private var photo: UIImage?
    @State private var conferenceIndex = 0

    @State private var showAddConference = false

    var conferenceName: String {
        if (conferenceIndex < storage.conferences.count) {
            return storage.conferences[conferenceIndex].name
        } else {
            return "Unknown"
        }
    }

    func save() {

    }

    func choosePhoto() {

    }

    func addConference() {
        showAddConference = true
    }

    var imageView: Image {
        photo != nil ? Image(uiImage: photo!) : Image(systemName: "person.circle.fill")
    }

    var body: some View {
        GeometryReader { geometry in
            Form {
                Section(header: Text("Info")) {
                    TextField("Name", text: self.$name)
                    DatePicker(selection: self.$date, displayedComponents: .date) {
                        Text("Date")
                    }
                }

                Section(header: Text("Photo")) {
                    VStack(alignment: .center) {
                        self.imageView
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width * 0.8)
                            .foregroundColor(.blue)
                            .clipShape(Circle())
                            .padding(5)
                            .onTapGesture { self.choosePhoto() }

                        Text("Tap photo to choose")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                }

                Section(header: Text("Conference")) {
                    if (self.storage.conferences.count > 0) {
                        Picker("\(self.conferenceName)", selection: self.$conferenceIndex) {
                            ForEach(self.storage.conferences) { conference in
                                Text("\(conference.name)")
                            }
                        }
                    }
                    Button(action: self.addConference) {
                        Text("New conference")
                    }
                }

                Section {
                    Button(action: self.save) {
                        Text("Add")
                    }
                }
            }
        }
        .sheet(isPresented: $showAddConference) {
            AddConferenceView { conference in
                self.storage.conferences.insert(conference, at: 0)
                self.conferenceIndex = 0
            }
        }
    }
}

struct AddPersonView_Previews: PreviewProvider {
    static var previews: some View {
        AddPersonView()
            .environmentObject(Storage.sample)
    }
}
