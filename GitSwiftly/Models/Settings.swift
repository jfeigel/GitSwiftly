//
//  Settings.swift
//  GitSwiftly
//
//  Created by jfeigel on 11/16/19.
//  Copyright © 2019 jfeigel. All rights reserved.
//

import Foundation
import UIKit
import Combine

final class Settings: ObservableObject {
    @Published var isDarkIcon: Bool {
        didSet {
            if oldValue != isDarkIcon {
                self.setIcon(isDarkIcon)
            }
        }
    }
    
    @Published var userInterfaceStyle: Int {
        didSet {
            SceneDelegate.shared?.window!.overrideUserInterfaceStyle = UIUserInterfaceStyle(rawValue: userInterfaceStyle)!
        }
    }
    
    static var userInterfaceStyleDict: [String] = ["System", "Light", "Dark"]
    
    init() {
        isDarkIcon = UIApplication.shared.alternateIconName != nil
        userInterfaceStyle = (SceneDelegate.shared?.window!.overrideUserInterfaceStyle.rawValue)!
    }
    
    private func setIcon(_ isDarkIcon: Bool) {
        UIApplication.shared.setAlternateIconName(isDarkIcon ? "AppIcon_Dark" : nil)
    }
}
