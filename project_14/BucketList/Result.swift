//
//  Result.swift
//  BucketList
//
//  Created by Nikolay Volosatov on 12/9/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import Foundation

struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [Int: Page]
}

struct Page: Codable {
    let pageid: Int
    let title: String
    let terms: [String: [String]]?
}

extension Page: Comparable {
    static func < (lhs: Page, rhs: Page) -> Bool {
        lhs.title < rhs.title
    }
}

extension Page {
    var description: String {
        terms?["description"]?.first ?? "No further information"
    }
}
