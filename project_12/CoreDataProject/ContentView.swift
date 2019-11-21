//
//  ContentView.swift
//  CoreDataProject
//
//  Created by Nikolay Volosatov on 11/19/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI
import CoreData

enum SortString<T> {
    case ascending(_ path: ReferenceWritableKeyPath<T, String?>)
    case descending(_ path: ReferenceWritableKeyPath<T, String?>)
}

extension SortString {
    var descriptor: NSSortDescriptor {
        switch self {
        case .ascending(let path):
            return NSSortDescriptor(keyPath: path, ascending: true)
        case .descending(let path):
            return NSSortDescriptor(keyPath: path, ascending: false)
        }
    }
}

enum FilterString {
    case contains(_ value: String)
    case beginsWith(_ value: String)
}

extension KeyPath where Root: NSObject {
    func filtered(_ filter: FilterString) -> NSPredicate {
        let keyName = NSExpression(forKeyPath: self).keyPath
        switch filter {
        case .contains(let substring):
            return NSPredicate(format: "\(keyName) CONTAINS %@", substring)
        case .beginsWith(let prefix):
            return NSPredicate(format: "\(keyName) BEGINSWITH %@", prefix)
        }
    }
}

struct FilteredList<T: NSManagedObject, V: View>: View {

    var fetchRequest: FetchRequest<T>
    var values: FetchedResults<T> { fetchRequest.wrappedValue }
    var content: (T) -> V

    init(sort: [SortString<T>], filter: (KeyPath<T, String?>, FilterString), @ViewBuilder content: @escaping (T) -> V) {
        let sortDescriptors = sort.map { $0.descriptor }
        fetchRequest = FetchRequest<T>(entity: T.entity(),
                                       sortDescriptors: sortDescriptors,
                                       predicate: filter.0.filtered(filter.1))
        self.content = content
    }

    var body: some View {
        List(values, id: \.self) { value in
            self.content(value)
        }
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @State var lastNameFilter = "A"
    @State var additionalSort = SortString.descending(\Singer.firstName)

    var body: some View {
        VStack {
            FilteredList(sort: [.ascending(\.lastName), additionalSort],
                         filter: (\.lastName, .beginsWith(lastNameFilter))) { (singer: Singer) in
                Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
            }

            Button("Add Examples") {
                let taylor = Singer(context: self.moc)
                taylor.firstName = "Taylor"
                taylor.lastName = "Swift"

                let swiftA = Singer(context: self.moc)
                swiftA.firstName = "A"
                swiftA.lastName = "Swift"

                let swiftB = Singer(context: self.moc)
                swiftB.firstName = "B"
                swiftB.lastName = "Swift"

                let ed = Singer(context: self.moc)
                ed.firstName = "Ed"
                ed.lastName = "Sheeran"

                let adele = Singer(context: self.moc)
                adele.firstName = "Adele"
                adele.lastName = "Adkins"

                try? self.moc.save()
            }

            Button("Show A") {
                self.lastNameFilter = "A"
            }

            Button("Show S") {
                self.lastNameFilter = "S"
            }

            Button("Sort ASC") {
                self.additionalSort = .ascending(\.firstName)
            }

            Button("Sort DESC") {
                self.additionalSort = .descending(\.firstName)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
