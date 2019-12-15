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
    @Environment(\.presentationMode) var presentationMode

    @State private var name = ""
    @State private var date = Date()
    @State private var photo: UIImage?
    @State private var conferenceIndex = 0

    @State private var showAddConference = false
    @State private var showImagePicker = false

    var conferenceName: String {
        if (conferenceIndex < storage.conferences.count) {
            return storage.conferences[conferenceIndex].name
        } else {
            return "Unknown"
        }
    }

    var imageView: Image {
        photo != nil ? Image(uiImage: photo!) : Image(systemName: "person.circle.fill")
    }

    var invalidationMessage: String? {
        if (name.count == 0) {
            return "Name is too short"
        }
        if (photo == nil) {
            return "Please, add photo"
        }
        if (self.storage.conferences.count == 0) {
            return "Add new conference first"
        }
        return nil
    }

    func save() {
        if let photo = photo, let photoId = try? self.storage.savePhoto(photo) {
            let person = Person(
                id: UUID(),
                name: name,
                date: date,
                conferenceId: self.storage.conferences[conferenceIndex].id,
                photoId: photoId
            )
            self.storage.people.append(person)
        }
        presentationMode.wrappedValue.dismiss()
    }

    func choosePhoto() {
        showImagePicker = true
    }

    func addConference() {
        showAddConference = true
    }

    var body: some View {
        GeometryReader { geometry in
            NavigationView {
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
                                .frame(width: min(geometry.size.width, geometry.size.height) * 0.4)
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

                    Section(header: Text("Event")) {
                        if (self.storage.conferences.count > 0) {
                            Picker("Select conference", selection: self.$conferenceIndex) {
                                ForEach(0..<self.storage.conferences.count, id: \.self) { index in
                                    Text("\(self.storage.conferences[index].name)")
                                }
                            }
                        }
                        Button(action: self.addConference) {
                            Text("New conference")
                        }
                    }

                    Section {
                        if (self.invalidationMessage != nil) {
                            Text(self.invalidationMessage!)
                                .font(.headline)
                                .foregroundColor(.red)
                        }
                        Button(action: self.save) {
                            Text("Add")
                        }
                        .disabled(self.invalidationMessage != nil)
                    }
                }
                .navigationBarTitle("New Preson")
            }
        }
        .sheet(isPresented: $showAddConference) {
            AddConferenceView { conference in
                self.storage.conferences.insert(conference, at: 0)
                self.conferenceIndex = 0
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: self.$photo)
        }
    }
}

struct AddPersonView_Previews: PreviewProvider {
    static var previews: some View {
        AddPersonView()
            .environmentObject(Storage.sample)
    }
}
