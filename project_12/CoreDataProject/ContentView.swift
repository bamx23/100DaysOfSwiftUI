//
//  ContentView.swift
//  CoreDataProject
//
//  Created by Nikolay Volosatov on 11/19/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI
import CoreData

struct FilteredList<T: NSManagedObject, V: View>: View {

    var fetchRequest: FetchRequest<T>
    var values: FetchedResults<T> { fetchRequest.wrappedValue }
    var subBody: (T) -> V

    init(key: String, filter: String, @ViewBuilder subBody: @escaping (T) -> V) {
        fetchRequest = FetchRequest<T>(entity: T.entity(),
                                       sortDescriptors: [],
                                       predicate: NSPredicate(format: "\(key) BEGINSWITH %@", filter))
        self.subBody = subBody
    }

    var body: some View {
        List(values, id: \.self) { value in
            self.subBody(value)
        }
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @State var lastNameFilter = "A"

    var body: some View {
        VStack {
            FilteredList(key: "lastName", filter: lastNameFilter) { (singer: Singer) in
                Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
            }

            Button("Add Examples") {
                let taylor = Singer(context: self.moc)
                taylor.firstName = "Taylor"
                taylor.lastName = "Swift"

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
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
