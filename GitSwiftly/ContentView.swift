//
//  ContentView.swift
//  GitSwiftly
//
//  Created by jfeigel on 10/29/19.
//  Copyright © 2019 jfeigel. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var env: Env
    
    @State var alert: Alert = nil
    @State var showAlert = false
    @State var showLogin = false
    
    var body: some View {
        NavigationView {
            Text("")
            .navigationBarTitle(Text("GitSwiftly"))
            .navigationBarItems(trailing:
                NavigationLink(destination: UserView().environmentObject(env)) {
                    Text("User")
                }
            )
            .onAppear(perform: { self.checkIsAuthorized() })
            .sheet(isPresented: $showLogin) {
                LoginView().environmentObject(self.env)
            }
            .alert(isPresented: $showAlert, content: { self.alert! })
        }
    }
    
    private func checkIsAuthorized() {
        env.gitHub.isAuthorized() {
            (isAuthorized, error) in
            if (error != nil) {
                self.alert = Alert(title: Text("Error"), message: Text(error!.localizedDescription))
                self.showAlert = true
            } else {
                self.showLogin = !isAuthorized
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
