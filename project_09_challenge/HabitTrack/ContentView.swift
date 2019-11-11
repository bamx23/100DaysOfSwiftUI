//
//  ContentView.swift
//  HabitTrack
//
//  Created by Nikolay Volosatov on 11/11/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

struct Activity: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    var time: TimeInterval
}

class ActivitiesData: ObservableObject {
    private static let KEY = "activities-data"

    @Published var activities: [Activity] {
        didSet {
            let encoder = JSONEncoder()
            guard let data = try? encoder.encode(self.activities) else {
                fatalError("Failed to encode activities")
            }
            UserDefaults.standard.set(data, forKey: Self.KEY)
        }
    }

    init() {
        self.activities = []
        guard let data = UserDefaults.standard.data(forKey: Self.KEY) else { return }
        let decoder = JSONDecoder()
        guard let activities = try? decoder.decode([Activity].self, from: data) else { return }
        self.activities = activities
    }
}

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode

    let completion: (Activity) -> Void

    @State private var name = ""
    @State private var description = ""

    var body: some View {
        Form {
            Section {
                TextField("Name", text: self.$name)
                TextField("Description", text: self.$description)
            }
            Button("Add") {
                let activity = Activity(id: UUID(), name: self.name, description: self.description, time: 0)
                self.completion(activity)
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct ContentView: View {
    @ObservedObject var data = ActivitiesData()

    @State private var addShown = false

    var body: some View {
        NavigationView {
            List {
                ForEach(data.activities) { activity in
                    VStack {
                        Text(activity.name)
                            .font(.headline)
                        Text(activity.description)
                            .font(.subheadline)
                    }
                }
                .onDelete(perform: { self.data.activities.remove(atOffsets: $0) })
            }
            .navigationBarTitle("HabitTrack")
            .navigationBarItems(leading: EditButton(),
                                trailing: Button(action: { self.addShown = true }) { Image(systemName: "plus") })
        }
        .sheet(isPresented: $addShown) {
            AddView { activity in
                self.data.activities.append(activity)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
