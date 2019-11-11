//
//  Repository.swift
//  GitSwiftly
//
//  Created by jfeigel on 11/8/19.
//  Copyright © 2019 jfeigel. All rights reserved.
//

import Foundation

struct Repository: Codable, Identifiable {
    var description: String?
    var id: String
    var name: String
    var url: String
    var primaryLanguage: PrimaryLanguage
    var stargazers: Stargazers

    struct PrimaryLanguage: Codable {
        var color: String
        var id: String
        var name: String
    }

    struct Stargazers: Codable {
        var totalCount: Int
    }
}

struct PinnedRepositories: Codable {
    var nodes: [Repository]
}
