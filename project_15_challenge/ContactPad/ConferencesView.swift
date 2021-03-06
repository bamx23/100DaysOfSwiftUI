//
//  ConferencesView.swift
//  ContactPad
//
//  Created by Nikolay Volosatov on 12/15/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

extension Conference {
    var displayDatesInterval: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        return "\(formatter.string(from: startDate)) - \(formatter.string(from: endDate))"
    }
}

struct ConferenceCardView: View {
    let conference: Conference

    var body: some View {
        VStack(alignment: .leading) {
            Text(conference.name)
                .font(.headline)
            Text(conference.displayDatesInterval)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

struct ConferencesView: View {
    @EnvironmentObject var storage: Storage

    @State private var showAddConference = false

    func add() {
        showAddConference = true
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(storage.conferences) { conference in
                    NavigationLink(destination: ConferenceView(conference: conference)) {
                        ConferenceCardView(conference: conference)
                    }
                }
                .onDelete(perform: { self.storage.conferences.remove(atOffsets: $0) })
            }
            .navigationBarTitle(Text("Conferences"))
            .navigationBarItems(leading: EditButton(),
                                trailing: Button(action: add){ Image(systemName: "plus").padding() })
        }
        .sheet(isPresented: $showAddConference) {
            AddConferenceView { conference in
                self.storage.conferences.insert(conference, at: 0)
            }
        }
    }
}

struct ConferencesView_Previews: PreviewProvider {
    static var previews: some View {
        ConferencesView()
            .environmentObject(Storage.sample)
    }
}
