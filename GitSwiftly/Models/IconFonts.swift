//
//  IconFonts.swift
//  GitSwiftly
//
//  Created by jfeigel on 11/1/19.
//  Copyright © 2019 jfeigel. All rights reserved.
//

import UIKit
import SwiftUI

public struct Devicon: View {
    let name: String
    let size: CGFloat
    
    init(_ name: String, size: CGFloat) {
        self.name = name
        self.size = size
    }
    
    public var body: some View {
        Text(String.deviconString(name))
            .font(Font.custom("devicon", size: size))
    }
}
    

public extension UIFont {
    class func iconFontOfSize(font: String, fontSize: CGFloat) -> UIFont {
        return UIFont(name: font, size: fontSize)!
    }
}

public extension String {
    static func deviconString(_ name: String) -> String {
        return fetchIconDevicon(name)
    }
}

public extension NSMutableAttributedString {
    static func deviconAttributedString(name: String, suffix: String?, iconSize: CGFloat, suffixSize: CGFloat?) -> NSMutableAttributedString {
        
        // Initialise some variables
        var iconString = fetchIconDevicon(name)
        var suffixFontSize = iconSize
        
        // If there is some suffix text - add it to the string
        if let suffix = suffix {
            iconString = iconString + suffix
        }
        
        // If there is a suffix font size - make a note
        if let suffixSize = suffixSize {
            suffixFontSize = suffixSize
        }
        
        // Build the initial string - using the suffix specifics
        let iconAttributed = NSMutableAttributedString(string: iconString, attributes: [NSAttributedString.Key.font:UIFont(name: "HelveticaNeue", size: suffixFontSize)!])
        
        // Role font awesome over the icon and size according to parameter
        iconAttributed.addAttribute(NSAttributedString.Key.font, value: UIFont.iconFontOfSize(font: "devicon", fontSize: iconSize), range: NSRange(location: 0, length: 1))
        
        return iconAttributed
    }
}


func fetchIconDevicon(_ name: String) -> String {
    var returnValue: String
    
    switch name {
    case "amazonwebservices": returnValue = "\u{e603}"
    case "android": returnValue = "\u{e60e}"
    case "angularjs": returnValue = "\u{e61d}"
    case "apache": returnValue = "\u{e627}"
    case "appcelerator": returnValue = "\u{e620}"
    case "apple": returnValue = "\u{e622}"
    case "atom": returnValue = "\u{e624}"
    case "babel": returnValue = "\u{e921}"
    case "coffeescript": returnValue = "\u{e66a}"
    case "css": returnValue = "\u{e679}"
    case "html": returnValue = "\u{e7f7}"
    case "javascript": returnValue = "\u{e845}"
    case "typescript": returnValue = "\u{e920}"
    case "react": returnValue = "\u{e601}"
    default : returnValue =  name
    }
    
    return returnValue
}
