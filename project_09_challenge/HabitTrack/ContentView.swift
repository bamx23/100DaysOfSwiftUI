//
//  ContentView.swift
//  HabitTrack
//
//  Created by Nikolay Volosatov on 11/11/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

protocol Progress: Identifiable, Codable {
    var id: UUID { get }
    var activityId: UUID { get }
    var date: Date { get }
}

extension Progress {
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }
}

struct CompletionProgress: Progress {
    let id: UUID
    let activityId: UUID
    let date: Date
}

struct TimeProgress: Progress {
    let id: UUID
    let activityId: UUID
    let date: Date
    let timeAmount: TimeInterval
}

extension TimeInterval {
    var string: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .brief
        return formatter.string(from: self)!
    }
}

enum ProgressType: Int, Codable {
    case completion = 0
    case time = 1
}

extension ProgressType {
    var iconName: String {
        switch self {
        case .completion:
            return "checkmark.seal.fill"
        case .time:
            return "clock.fill"
        }
    }
    var color: Color {
        switch self {
        case .completion:
            return .green
        case .time:
            return .blue
        }
    }
    var name: String {
        switch self {
        case .completion:
            return "Completions"
        case .time:
            return "Time"
        }
    }
}

struct Activity: Identifiable, Codable {
    typealias ID = UUID

    let id: UUID
    let name: String
    let description: String
    let type: ProgressType
}

class ActivitiesData: ObservableObject {
    private static let ACTIVITIES_KEY = "activities-data"
    private static let COMPLETION_PROGRESS_KEY = "completion-progress-data"
    private static let TIME_PROGRESS_KEY = "time-progress-data"

    @Published var activities: [Activity] {
        didSet {
            Self.encode(self.activities, key: Self.ACTIVITIES_KEY)
        }
    }
    @Published var completionProgress: [Activity.ID:[CompletionProgress]] {
        didSet {
            Self.encode(self.completionProgress, key: Self.COMPLETION_PROGRESS_KEY)
        }
    }
    @Published var timeProgress: [Activity.ID:[TimeProgress]] {
        didSet {
            Self.encode(self.timeProgress, key: Self.TIME_PROGRESS_KEY)
        }
    }

    private static func encode<T: Encodable>(_ value: T, key: String) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(value) else {
            fatalError("Failed to encode \(value)")
        }
        UserDefaults.standard.set(data, forKey: key)
    }

    private static func decode<T: Decodable>(key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        let decoder = JSONDecoder()
        guard let value = try? decoder.decode(T.self, from: data) else { return nil }
        return value
    }

    init() {
        self.activities = Self.decode(key: Self.ACTIVITIES_KEY) ?? []
        self.completionProgress = Self.decode(key: Self.COMPLETION_PROGRESS_KEY) ?? [:]
        self.timeProgress = Self.decode(key: Self.TIME_PROGRESS_KEY) ?? [:]
    }

    func timeFor(activity: Activity) -> TimeInterval? { timeProgress[activity.id]?.reduce(0, { $0 + $1.timeAmount }) }
    func countFor(activity: Activity) -> Int? { completionProgress[activity.id]?.count }
}

extension View {
    func card(_ title: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.white)
            self
                .layoutPriority(1)
                .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct AddTimeButton: View {
    let time: TimeInterval
    let action: (TimeInterval) -> Void

    var body: some View {
        Button("+\(time.string)") {
            self.action(self.time)
        }
        .frame(width: 70)
        .background(Color.green)
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}

struct DetailsView: View {
    @EnvironmentObject var data: ActivitiesData

    let activity: Activity

    @State private var selectedTime: TimeInterval = 0

    var count: Int { data.completionProgress[activity.id]?.count ?? 0 }
    var timeString: String { return data.timeFor(activity: activity)?.string ?? "No time spent yet" }

    func addCompletion() {
        let progress = CompletionProgress(id: UUID(),
                                          activityId: activity.id,
                                          date: Date())
        var values = self.data.completionProgress[activity.id] ?? []
        values.insert(progress, at: 0)
        withAnimation {
            self.data.completionProgress[activity.id] = values
        }
    }

    func addTime() {
        let progress = TimeProgress(id: UUID(),
                                    activityId: activity.id,
                                    date: Date(),
                                    timeAmount: self.selectedTime)
        var values = self.data.timeProgress[activity.id] ?? []
        values.insert(progress, at: 0)
        withAnimation {
            self.selectedTime = 0
            self.data.timeProgress[activity.id] = values
        }
    }

    func addSelectedTime(time: TimeInterval) {
        withAnimation {
            selectedTime += time
        }
    }

    func deleteCompletion(at indexSet: IndexSet) {
        if var history = self.data.completionProgress[activity.id] {
            history.remove(atOffsets: indexSet)
            self.data.completionProgress[activity.id] = history
        }
    }

    func deleteTime(at indexSet: IndexSet) {
        if var history = self.data.timeProgress[activity.id] {
            history.remove(atOffsets: indexSet)
            self.data.timeProgress[activity.id] = history
        }
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text(self.activity.description)
                        .font(.body)
                        .foregroundColor(.white)
                }
                .card("Description")

                if self.activity.type == .completion {
                    VStack {
                        HStack(spacing: 20) {
                            Text("\(self.count)")
                                .font(Font.largeTitle.monospacedDigit())
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                            Button(action: self.addCompletion) {
                                Image(systemName: ProgressType.completion.iconName)
                                    .font(.largeTitle)
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    .card("Completions count")

                    List {
                        ForEach(self.data.completionProgress[self.activity.id] ?? []) { progress in
                            Text(progress.dateString)
                                .foregroundColor(.primary)
                        }
                        .onDelete(perform: self.deleteCompletion)
                    }
                    .shadow(radius: 10)
                    .card("History")
                } else if self.activity.type == .time {
                    Text(self.timeString)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .shadow(radius: 10)
                        .card("Already spent")

                    VStack {
                        Text(self.selectedTime.string)
                            .padding()
                            .background(Color.yellow)
                            .foregroundColor(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .shadow(radius: 10)
                        HStack {
                            VStack {
                                HStack {
                                    AddTimeButton(time: 60, action: self.addSelectedTime)
                                    AddTimeButton(time: 600, action: self.addSelectedTime)
                                    AddTimeButton(time: 1800, action: self.addSelectedTime)
                                }
                                HStack {
                                    AddTimeButton(time: 3600, action: self.addSelectedTime)
                                    AddTimeButton(time: 7200, action: self.addSelectedTime)
                                    Button(action: { withAnimation { self.selectedTime = 0 } }) {
                                        Image(systemName: "clear.fill")
                                            .frame(width: 70)
                                            .foregroundColor(.yellow)
                                    }
                                }
                            }
                            .padding()
                            Button(action: self.addTime) {
                                Image(systemName: ProgressType.time.iconName)
                                    .font(.largeTitle)
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    .card("Spend more")

                    List {
                        ForEach(self.data.timeProgress[self.activity.id] ?? []) { progress in
                            VStack(alignment: .leading) {
                                Text(progress.timeAmount.string)
                                    .foregroundColor(.primary)
                                Text(progress.dateString)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .onDelete(perform: self.deleteTime)
                    }
                    .frame(maxHeight: .infinity)
                    .shadow(radius: 10)
                    .card("History")
                }
            }
            .frame(width: geometry.size.width * 0.9)
        }
        .padding(.vertical)
        .navigationBarTitle(Text(activity.name), displayMode: .inline)
    }
}

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var data: ActivitiesData

    @State private var name = ""
    @State private var description = ""
    @State private var type = ProgressType.completion

    var body: some View {
        VStack(alignment: .leading) {
            Text("Add Activity")
                .font(.largeTitle)
                .padding()
            Form {
                Section(header: Text("Info")) {
                    TextField("Name", text: self.$name)
                    TextField("Description", text: self.$description)
                }
                Section(header: Text("Type")) {
                    VStack {
                        Image(systemName: type.iconName)
                            .font(.system(size: 60))
                            .foregroundColor(type.color)
                            .padding()
                        Picker("Type", selection: $type) {
                            ForEach([ProgressType.completion, ProgressType.time], id: \.self) { type in
                                Text(type.name)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
                Button("Add") {
                    let activity = Activity(id: UUID(),
                                            name: self.name,
                                            description: self.description,
                                            type: self.type)
                    self.data.activities.append(activity)
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var data: ActivitiesData

    @State private var addShown = false

    func additionalTextFor(activity: Activity) -> String {
        switch activity.type {
        case .completion:
            return "x\(self.data.countFor(activity: activity) ?? 0)"
        case .time:
            return self.data.timeFor(activity: activity)?.string ?? ""
        }
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(data.activities) { activity in
                    NavigationLink(destination: DetailsView(activity: activity)) {
                        Image(systemName: activity.type.iconName)
                            .font(.largeTitle)
                            .foregroundColor(activity.type.color)
                            .frame(width: 50)
                        VStack(alignment: .leading) {
                            Text(activity.name)
                                .font(.headline)
                            Text(activity.description)
                                .font(.subheadline)
                            Text(self.additionalTextFor(activity: activity))
                                .frame(maxWidth: .infinity)
                                .padding(5)
                                .background(activity.type.color)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(5)
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
            .environmentObject(ActivitiesData())
    }
}
