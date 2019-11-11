//
//  User.swift
//  GitSwiftly
//
//  Created by jfeigel on 10/29/19.
//  Copyright © 2019 jfeigel. All rights reserved.
//

import Foundation

struct UserResponse: Codable {
    var data: UserData
}

struct UserData: Codable {
    var viewer: User
}

struct User: Codable {
    var avatarUrl: String
    var company: String
    var id: String
    var login: String
    var name: String
    var url: String
    var pinnedRepositories: PinnedRepositories
}
