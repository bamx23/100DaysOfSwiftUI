//
//  FilteredListView.swift
//  WeFriends
//
//  Created by Nikolay Volosatov on 11/23/19.
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
            return substring.count == 0
                ? NSPredicate(value: true)
                : NSPredicate(format: "\(keyName) CONTAINS %@", substring)
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
        ForEach(values, id: \.self) { value in
            self.content(value)
        }
    }
}

struct FilteredListView_Previews: PreviewProvider {
    static var previews: some View {
        Text("N/A")
    }
}
