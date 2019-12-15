//
//  Storage.swift
//  ContactPad
//
//  Created by Nikolay Volosatov on 12/15/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import Foundation

struct Person: Identifiable, Codable {
    typealias ID = UUID
    let id: ID
    let name: String
    let date: Date

    let conferenceId: Conference.ID
    let photoId: UUID
}

struct Conference: Identifiable, Codable {
    typealias ID = UUID
    let id: ID
    let name: String
    let startDate: Date
    let endDate: Date
}

class Storage: ObservableObject {
    @Published var people: [Person] {
        didSet {
            try? save(people)
        }
    }
    @Published var conferences: [Conference] {
        didSet {
            try? save(conferences)
        }
    }

    init() {
        self.people = []
        self.conferences = []
    }

    init(people: [Person], conferences: [Conference]) {
        self.people = people
        self.conferences = conferences
    }

    func load() {
        people = (try? load()) ?? []
        conferences = (try? load()) ?? []
    }
}

extension Storage {
    private func getFilePath<T>(_ subject: T) -> URL {
        guard let basePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Failed to find Documents directory")
        }
        let typeName = String(describing: T.self)
        let filePath = basePath.appendingPathComponent(typeName, isDirectory: false).appendingPathExtension("json")
        return filePath
    }

    private func load<T: Decodable>() throws -> [T] {
        let filePath = getFilePath(T.self)
        let data = try Data(contentsOf: filePath)
        let result = try JSONDecoder().decode([T].self, from: data)
        return result
    }

    private func save<T: Encodable>(_ value: [T]) throws {
        let filePath = getFilePath(T.self)
        let data = try JSONEncoder().encode(value)
        try data.write(to: filePath)
    }
}

extension Storage {
    static var sample: Storage {
        let p1 = UUID()
        let p2 = UUID()
        let c1 = UUID()
        return Storage(people: [
            Person(
                id: p1,
                name: "Jack Black",
                date: Date(timeIntervalSince1970: 1576432367),
                conferenceId: c1,
                photoId: UUID()
            ),
            Person(
                id: p2,
                name: "Taylor Swift",
                date: Date(timeIntervalSince1970: 1576431367),
                conferenceId: c1,
                photoId: UUID()
            ),
        ], conferences: [
            Conference(
                id: c1,
                name: "Swift by Example",
                startDate: Date(timeIntervalSince1970: 1576132367),
                endDate: Date(timeIntervalSince1970: 1576532367)
            )
        ])
    }
}
