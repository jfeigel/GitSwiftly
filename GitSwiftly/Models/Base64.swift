//
//  Base64.swift
//  GitSwiftly
//
//  Created by jfeigel on 11/11/19.
//  Copyright © 2019 jfeigel. All rights reserved.
//

import Foundation

extension String {
//: ### Base64 encoding a string
    func base64Encoded() -> String {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return ""
    }

//: ### Base64 decoding a string
    func base64Decoded() -> String {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8) ?? ""
        }
        return ""
    }
}
