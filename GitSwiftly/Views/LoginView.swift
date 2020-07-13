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
    
    @EnvironmentObject var gitHub: GitHub
    
    @State private var showAlert = false
    @State private var alert: Alert?
    
    var body: some View {
        Button(action: { self.login() }) {
            Text("LOGIN")
        }
        .alert(isPresented: $showAlert, content: { self.alert! })
    }
    
    private func login() {
        gitHub.login() {
            (error) in
            if error != nil {
                self.alert = Alert(title: Text("Error"), message: Text(error!.localizedDescription))
                self.showAlert = true
            } else {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
