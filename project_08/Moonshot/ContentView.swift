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

extension Bundle {
    func decode(_ file: String) -> [Astronaut] {
        guard let url = self.url(forResource: file, withExtension: "json") else {
            fatalError("File not found: \(file).json")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load data of \(file).json")
        }
        let decoder = JSONDecoder()
        guard let result = try? decoder.decode([Astronaut].self, from: data) else {
            fatalError("Failed to decode astronaouts from \(file).json")
        }
        return result
    }
}

struct ContentView: View {
    let astronauts = Bundle.main.decode("astronauts")

    var body: some View {
        NavigationView {
            List(astronauts) { astronaut in
                Text(astronaut.name)
                    .font(.title)
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
