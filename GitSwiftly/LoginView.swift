//
//  LoginView.swift
//  GitSwiftly
//
//  Created by jfeigel on 10/29/19.
//  Copyright © 2019 jfeigel. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var env: Env
    
    @State private var showAlert = false
    @State private var alert: Alert = nil
    
    var body: some View {
        Button(action: { self.login() }) {
            Text("LOGIN")
        }
        .alert(isPresented: $showAlert, content: { self.alert! })
    }
    
    private func login() {
        env.gitHub.login() {
            (accessToken, claims, error) in
            if (error != nil) {
                self.alert = Alert(title: Text("Error"), message: Text(error!.localizedDescription))
            } else {
                self.alert = Alert(title: Text("Success"),
                                   message: Text("Successfully logged in"),
                                   dismissButton: Alert.Button.default(Text("Dismiss"), action: { self.presentationMode.wrappedValue.dismiss() })
                )
                
            }
            
            self.showAlert = true
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
