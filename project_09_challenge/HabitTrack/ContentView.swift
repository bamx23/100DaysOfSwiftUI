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
    var completionsCount: Int
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

extension View {
    func card(_ title: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.white)
            self
                .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color.blue)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct DetailsView: View {
    let activity: Activity

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text(self.activity.description)
                        .font(.body)
                        .foregroundColor(.white)
                }
                .card("Description")

                VStack {
                    HStack(spacing: 20) {
                        Button(action: {}) {
                            Image(systemName: "minus.rectangle")
                                .font(.title)
                                .foregroundColor(.yellow)
                        }
                        Text("\(self.activity.completionsCount)")
                            .font(.largeTitle)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                        Button(action: {}) {
                            Image(systemName: "checkmark.rectangle")
                                .font(.largeTitle)
                                .foregroundColor(.green)
                        }
                    }
                }
                .card("Completions count")

                Spacer()
            }
            .frame(width: geometry.size.width * 0.9)
        }
        .navigationBarTitle(Text(activity.name), displayMode: .inline)
    }
}

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var data: ActivitiesData

    @State private var name = ""
    @State private var description = ""

    var body: some View {
        Form {
            Section {
                TextField("Name", text: self.$name)
                TextField("Description", text: self.$description)
            }
            Button("Add") {
                let activity = Activity(id: UUID(),
                                        name: self.name,
                                        description: self.description,
                                        completionsCount: 0)
                self.data.activities.append(activity)
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
                    NavigationLink(destination: DetailsView(activity: activity)) {
                        VStack {
                            Text(activity.name)
                                .font(.headline)
                            Text(activity.description)
                                .font(.subheadline)
                        }
                    }
                }
                .onDelete(perform: { self.data.activities.remove(atOffsets: $0) })
            }
            .navigationBarTitle("HabitTrack")
            .navigationBarItems(leading: EditButton(),
                                trailing: Button(action: { self.addShown = true }) { Image(systemName: "plus") })
        }
        .sheet(isPresented: $addShown) { AddView(data: self.data) }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
