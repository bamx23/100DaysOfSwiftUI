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

struct ContentView: View {
    let astronauts: [Astronaut] = Bundle.main.decode("astronauts")
    let missions: [Mission] = Bundle.main.decode("missions")

    var body: some View {
        NavigationView {
            List(missions) { mission in
                NavigationLink(destination: Text("Detail view")) {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)

                    VStack(alignment: .leading) {
                        Text(mission.displayName)
                            .font(.headline)
                        Text(mission.formattedLaunchDate)
                    }
                }
            }
            .navigationBarTitle("Moonshot")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
