//
//  Friend.swift
//  WeFriends
//
//  Created by Nikolay Volosatov on 11/22/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import Foundation

struct Friend: Codable, Identifiable {
    let id: UUID
    let name: String
}
