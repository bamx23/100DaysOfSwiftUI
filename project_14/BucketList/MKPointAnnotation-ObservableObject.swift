//
//  MKPointAnnotation-ObservableObject.swift
//  BucketList
//
//  Created by Nikolay Volosatov on 12/3/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import Foundation
import MapKit

extension MKPointAnnotation: ObservableObject {
    public var wrappedTitle: String {
        get { title ?? "-" }
        set { title = newValue }
    }
    public var wrappedSubtitle: String {
        get { subtitle ?? "-" }
        set { subtitle = newValue }
    }
}
