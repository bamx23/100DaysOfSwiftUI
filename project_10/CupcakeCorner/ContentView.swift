//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Nikolay Volosatov on 11/12/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}

struct ContentView: View {

    @State private var results: [Result] = []

    func loadData() {
        let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song")!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let decoder = JSONDecoder()
            guard error == nil, (response as? HTTPURLResponse)?.statusCode == 200 else {
                return
            }
            guard let data = data, let responseData = try? decoder.decode(Response.self, from: data) else {
                return
            }
            DispatchQueue.main.async {
                self.results = responseData.results
            }
        }
        task.resume()
    }

    var body: some View {
        List(results, id: \.trackId) { item in
            VStack(alignment: .leading) {
                Text(item.trackName)
                    .font(.headline)
                Text(item.collectionName)
            }
        }
        .onAppear(perform: loadData)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
