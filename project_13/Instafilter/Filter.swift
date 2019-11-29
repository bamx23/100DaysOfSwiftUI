//
//  Filter.swift
//  Instafilter
//
//  Created by Nikolay Volosatov on 11/29/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import Foundation
import CoreImage

struct Filter {
    let name: String
    let ciFilter: () -> CIFilter
}

extension Filter: Identifiable {
    var id: String { name }
}

extension Filter {
    static func crystallize() -> Self {
        Filter(name: "Crystallize") { CIFilter.crystallize() }
    }
    static func edges() -> Self {
        Filter(name: "Edges") { CIFilter.edges() }
    }
    static func gaussianBlur() -> Self {
        Filter(name: "Gaussian Blur") { CIFilter.gaussianBlur() }
    }
    static func pixellate() -> Self {
        Filter(name: "Pixellate") { CIFilter.pixellate() }
    }
    static func sepiaTone() -> Self {
        Filter(name: "Sepia Tone") { CIFilter.sepiaTone() }
    }
    static func unsharpMask() -> Self {
        Filter(name: "Unsharp Mask") { CIFilter.unsharpMask() }
    }
    static func vignette() -> Self {
        Filter(name: "Vignette") { CIFilter.vignette() }
    }

    static var allFilters: [Filter] {
        [
            .crystallize(),
            .edges(),
            .gaussianBlur(),
            .pixellate(),
            .sepiaTone(),
            .unsharpMask(),
            .vignette(),
        ]
    }
}
