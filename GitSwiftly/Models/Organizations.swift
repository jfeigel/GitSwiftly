//
//  Organizations.swift
//  GitSwiftly
//
//  Created by jfeigel on 11/11/19.
//  Copyright © 2019 jfeigel. All rights reserved.
//

import Foundation

struct Organization: Codable, Identifiable {
    var avatarUrl: String
    var id: String
    var name: String
}

struct Organizations: Codable {
    var nodes: [Organization]
}
