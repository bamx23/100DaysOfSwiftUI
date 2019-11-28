//
//  FilterOption.swift
//  Instafilter
//
//  Created by Nikolay Volosatov on 11/28/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import Foundation
import CoreImage

enum FilterOption: String, CaseIterable {
    case intensity
    case radius
    case scale
}

extension FilterOption: Identifiable {
    var id: String { self.rawValue }
    var name: String { self.rawValue.capitalized }

    var key: String {
        switch self {
        case .intensity:
            return kCIInputIntensityKey
        case .radius:
            return kCIInputRadiusKey
        case .scale:
            return kCIInputScaleKey
        }
    }

    var range: ClosedRange<Double> {
        switch self {
        case .intensity:
            return 0...1
        case .radius:
            return 0...200
        case .scale:
            return 0...10
        }
    }

    var defaultValue: Double { (self.range.lowerBound + self.range.upperBound) / 2 }

    static func allCases(forFilter filter: CIFilter) -> [FilterOption] {
        Self.allCases.filter { filter.inputKeys.contains($0.key) }
    }
}
