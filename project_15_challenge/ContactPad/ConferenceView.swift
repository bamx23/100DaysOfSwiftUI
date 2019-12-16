//
//  ConferenceView.swift
//  ContactPad
//
//  Created by Nikolay Volosatov on 12/16/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

struct ConferenceView: View {
    @EnvironmentObject var storage: Storage

    let conference: Conference

    var people: [Person] {
        storage.people.filter { $0.conferenceId == conference.id }
    }

    var body: some View {
        VStack {
            Text(conference.displayDatesInterval)
                .font(.subheadline)
                .foregroundColor(.secondary)
            List(people) { person in
                NavigationLink(destination: PersonView(person: person)) {
                    PersonCardView(person: person)
                }
            }
        }
        .navigationBarTitle(Text(conference.name))
    }
}

struct ConferenceView_Previews: PreviewProvider {
    static var previews: some View {
        let storage = Storage.sample
        return NavigationView {
            ConferenceView(conference: storage.conferences.first!)
                .environmentObject(storage)
        }
    }
}
