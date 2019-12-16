//
//  PeopleView.swift
//  ContactPad
//
//  Created by Nikolay Volosatov on 12/15/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

extension Person {
    var displayDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }

    func imageView(storage: Storage) -> Image {
        if let uiImage = storage.loadPhoto(id: photoId) {
            return Image(uiImage: uiImage)
        } else {
            return Image(systemName: "person.circle.fill")
        }
    }
}

struct PersonCardView: View {
    @EnvironmentObject var storage: Storage

    let person: Person

    var conference: Conference? {
        storage.conferences.first(where: { $0.id == person.conferenceId })
    }
    var conferenceName: String {
        conference?.name ?? "Unknown conference"
    }
    var body: some View {
        HStack {
            person.imageView(storage: storage)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .foregroundColor(.blue)
                .clipShape(Circle())
                .padding(5)
            VStack(alignment: .leading) {
                Text(person.name)
                    .font(.headline)
                Text(person.displayDate)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(conferenceName)
                    .font(.subheadline)
                Spacer()
            }
            .padding()
        }
    }
}

struct PeopleView: View {
    @EnvironmentObject var storage: Storage

    @State private var showAddPerson = false
    @State private var newPerson: Person?

    func add() {
        showAddPerson = true
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(storage.people) { person in
                    NavigationLink(destination: PersonView(person: person)) {
                        PersonCardView(person: person)
                            .environmentObject(self.storage)
                    }
                }
                .onDelete(perform: { self.storage.people.remove(atOffsets:$0) })
            }
            .navigationBarTitle(Text("People"))
            .navigationBarItems(leading: EditButton(),
                                trailing: Button(action: add){ Image(systemName: "plus").padding() })
        }
        .sheet(isPresented: $showAddPerson) {
            AddPersonView()
                .environmentObject(self.storage)
        }
    }
}

struct PeopleView_Previews: PreviewProvider {
    static var previews: some View {
        PeopleView()
            .environmentObject(Storage.sample)
    }
}
