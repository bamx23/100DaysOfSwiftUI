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
        return "\(formatter.string(from: startDate)) - \(formatter.string(from: endDate))"
    }
}

struct ConferencesView: View {
    @EnvironmentObject var storage: Storage

    var body: some View {
        NavigationView {
            List {
                ForEach(storage.conferences) { conference in
                    VStack(alignment: .leading) {
                        Text(conference.name)
                            .font(.headline)
                        Text(conference.displayDatesInterval)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .onDelete(perform: { self.storage.conferences.remove(atOffsets: $0) })
            }
            .navigationBarTitle(Text("Conferences"))
            .navigationBarItems(leading: EditButton())
        }
    }
}

struct ConferencesView_Previews: PreviewProvider {
    static var previews: some View {
        ConferencesView()
            .environmentObject(Storage.sample)
    }
}
