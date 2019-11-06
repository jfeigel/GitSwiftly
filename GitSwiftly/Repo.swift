//
//  Repo.swift
//  GitSwiftly
//
//  Created by jfeigel on 11/2/19.
//  Copyright © 2019 jfeigel. All rights reserved.
//

import Foundation

struct Repo: Codable, Identifiable {
    var id: Int
    var name: String
    var html_url: String
    var description: String?
    var language: String?
}
