//
//  Env.swift
//  GitSwiftly
//
//  Created by jfeigel on 10/29/19.
//  Copyright © 2019 jfeigel. All rights reserved.
//

import Foundation

class Env: ObservableObject {
    @Published var gitHub: GitHub = GitHub()
}
