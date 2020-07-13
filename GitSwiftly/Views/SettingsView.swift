//
//  SettingsView.swift
//  GitSwiftly
//
//  Created by jfeigel on 11/16/19.
//  Copyright © 2019 jfeigel. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var settings = Settings()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("APPEARANCE")) {
                    Toggle(isOn: self.$settings.isDarkIcon) {
                        Text("Use Dark App Icon")
                    }
                    HStack {
                        Text("User Interface Style")
                        Spacer()
                        Picker(selection: self.$settings.userInterfaceStyle, label: Text("User Interface Style")) {
                            ForEach(0 ..< Settings.userInterfaceStyleDict.count) {
                                Text(Settings.userInterfaceStyleDict[$0])
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
            }
            .navigationBarTitle("Settings")
            .navigationBarItems(trailing: Button("Done", action: { self.presentationMode.wrappedValue.dismiss() }))
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
