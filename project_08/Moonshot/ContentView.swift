//
//  ContentView.swift
//  Moonshot
//
//  Created by Nikolay Volosatov on 11/5/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

struct Astronaut: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
}

struct Mission: Codable, Identifiable {
    struct CrewRole: Codable {
        let name: String
        let role: String
    }

    let id: Int
    let launchDate: Date?
    let crew: [CrewRole]
    let description: String

    var displayName: String { "Apollo \(id)" }
    var image: String { "apollo\(id)" }
    var formattedLaunchDate: String {
        guard let launchDate = launchDate else {
            return "N/A"
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: launchDate)
    }
}

extension Bundle {
    func decode<T: Decodable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: "json") else {
            fatalError("File not found: \(file).json")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load data of \(file).json")
        }
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        guard let result = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode astronaouts from \(file).json")
        }
        return result
    }
}

struct MissionTitleView: View {
    enum Style {
        case launchDate
        case crewNames
    }

    @EnvironmentObject var data: MoonshotData

    let mission: Mission
    let style: Style

    private var crewNames: [String] {
        mission.crew.map { crewMember in
            guard let astronaut = data.astronauts.first(where: { $0.id == crewMember.name }) else {
                fatalError("Astronaut not found")
            }
            return astronaut.name
        }
    }
    private var subtitles: [String] {
        switch style {
        case .crewNames:
            return crewNames
        case .launchDate:
            return [mission.formattedLaunchDate]
        }
    }

    var body: some View {
        HStack {
            Image(mission.image)
                .resizable()
                .scaledToFit()
                .frame(width: 44, height: 44)

            VStack(alignment: .leading) {
                Text(mission.displayName)
                    .font(.headline)
                VStack(alignment: .leading) {
                    ForEach(subtitles, id: \.self) { name in
                        Text(name)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.bottom)
            }
            Spacer()
        }
        .accessibilityElement(children: .ignore)
        .accessibility(label: Text("Mission: \(mission.displayName)"))
        .accessibility(hint: Text("\(mission.displayName). " +
                                  "Launch date is \(mission.formattedLaunchDate). " +
                                  "Crew: \(crewNames.joined(separator: ", "))"))
    }
}

struct AstronautView: View {
    @EnvironmentObject var data: MoonshotData

    let astronaut: Astronaut
    var missions: [Mission] {
        data.missions.filter { mission in
            mission.crew.contains { crewMember in
                crewMember.name == astronaut.id
            }
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(self.astronaut.id)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)

                    Text(self.astronaut.description)
                        .padding()
                        .layoutPriority(1)

                    VStack {
                        Text("Missions:")
                        ForEach(self.missions) { mission in
                            MissionTitleView(mission: mission, style: .launchDate)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitle(Text(astronaut.name), displayMode: .inline)
    }
}

struct MissionView: View {
    struct CrewMember: Identifiable {
        var id: String { role }
        let role: String
        let astronaut: Astronaut
    }

    @EnvironmentObject var data: MoonshotData

    let mission: Mission
    var astronauts: [CrewMember] {
        mission.crew.map { member in
            if let match = self.data.astronauts.first(where: { $0.id == member.name }) {
                return CrewMember(role: member.role, astronaut: match)
            } else {
                fatalError("Missing \(member)")
            }
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(self.mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: geometry.size.width * 0.7)
                        .padding(.top)

                    HStack {
                        Text(self.mission.formattedLaunchDate)
                            .font(.headline)
                            .accessibility(label: Text("Launch date is \(self.mission.formattedLaunchDate)"))
                        Spacer()
                    }
                    .padding()

                    Text(self.mission.description)
                        .padding()

                    ForEach(self.astronauts) { crewMember in
                        NavigationLink(destination: AstronautView(astronaut: crewMember.astronaut)) {
                            HStack {
                                Image(crewMember.astronaut.id)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 65)
                                    .clipShape(Capsule())
                                    .overlay(Capsule().stroke(Color.primary, lineWidth: 1))
                                VStack(alignment: .leading) {
                                    Text(crewMember.astronaut.name)
                                        .font(.headline)
                                    Text(crewMember.role)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }

                    Spacer(minLength: 25)
                }
            }
        }
        .navigationBarTitle(Text(mission.displayName), displayMode: .inline)
    }
}

struct ContentView: View {
    @EnvironmentObject var data: MoonshotData

    @State private var showCrewNames = false

    var astronauts: [Astronaut] { data.astronauts }
    var missions: [Mission] { data.missions }

    var titleStyle: MissionTitleView.Style { showCrewNames ? .crewNames : .launchDate }

    var body: some View {
        NavigationView {
            List(missions) { mission in
                NavigationLink(destination: MissionView(mission: mission)) {
                    MissionTitleView(mission: mission, style: self.titleStyle)
                }
            }
            .navigationBarTitle("Moonshot")
            .navigationBarItems(trailing: Button(action: { withAnimation { self.showCrewNames.toggle() } }) {
                Text(showCrewNames ? "Crew" : "Launch date")
                .accessibility(label: Text("Details: \(showCrewNames ? "Crew" : "Launch date")"))
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
