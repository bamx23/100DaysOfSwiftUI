//
//  Genre.swift
//  Bookworm
//
//  Created by Nikolay Volosatov on 11/18/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import Foundation

enum Genre: String, CaseIterable {
    case fantasy
    case horror
    case kids
    case mystery
    case poetry
    case romance
    case thriller
}

extension Genre {
    var title: String { rawValue.capitalized }
    var badgeTitle: String { rawValue.uppercased() }
    var imageName: String { rawValue.capitalized }
    static var defaultGenre: Genre { .fantasy }
}

extension Book {
    var genreType: Genre {
        guard let genre = genre else {
            return .defaultGenre
        }
        return Genre(rawValue: genre.lowercased()) ?? .defaultGenre
    }
}
