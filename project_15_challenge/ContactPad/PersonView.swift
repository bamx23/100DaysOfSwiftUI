//
//  PersonView.swift
//  ContactPad
//
//  Created by Nikolay Volosatov on 12/16/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

struct PersonView: View {
    @EnvironmentObject var storage: Storage

    let person: Person

    var conference: Conference? {
        self.storage.conferences.first(where: { $0.id == self.person.conferenceId })
    }

    var body: some View {
        GeometryReader { (geometry: GeometryProxy) in
            ScrollView {
                VStack {
                    self.person.imageView(storage: self.storage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)
                        .frame(minHeight: 300, maxHeight: .infinity)
                        .padding(.bottom)
                        .layoutPriority(10.0)
                    Text(self.person.displayDate)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    if self.conference != nil {
                        VStack(alignment: .leading) {
                            Text("Event")
                                .font(.title)
                            ConferenceCardView(conference: self.conference!)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity,
                               minHeight: 100, maxHeight: .infinity,
                               alignment: .topLeading)

                    }
                }
            }
        }
        .navigationBarTitle(Text(self.person.name), displayMode: .inline)
    }
}

struct PersonView_Previews: PreviewProvider {
    static var previews: some View {
        let storage = Storage.sample;
        return NavigationView {
            PersonView(person: storage.people.first!)
                .environmentObject(storage)
        }
    }
}
