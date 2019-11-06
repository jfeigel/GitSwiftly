//
//  ContentView.swift
//  GitSwiftly
//
//  Created by jfeigel on 10/29/19.
//  Copyright © 2019 jfeigel. All rights reserved.
//

import SwiftUI
import struct Kingfisher.KFImage

struct ContentView: View {
    @EnvironmentObject var gitHub: GitHub
    
    @State private var alert: Alert = nil
    @State private var showAlert = false
    @State private var showLogin = false
    
    var body: some View {
        NavigationView {
            Text("")
            .navigationBarTitle(Text("GitSwiftly"))
            .navigationBarItems(trailing:
                NavigationLink(destination: UserView().environmentObject(gitHub)) {
                    if self.gitHub.user == nil {
                        Image(systemName: "person.circle.fill")
                    } else {
                        KFImage(URL(string: self.gitHub.user!.avatar_url))
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    }
                }
                .disabled(self.gitHub.user == nil)
                .buttonStyle(PlainButtonStyle())
            )
            .sheet(isPresented: $showLogin) {
                LoginView().environmentObject(self.gitHub)
            }
            .alert(isPresented: $showAlert, content: { self.alert! })
        }
        .onAppear(perform: { self.checkIsAuthorized() })
    }
    
    private func checkIsAuthorized() {
        gitHub.isAuthorized() {
            (isAuthorized, error) in
            if error != nil {
                self.alert = Alert(title: Text("Error"), message: Text(error!.localizedDescription))
                self.showAlert = true
            } else {
                self.showLogin = !isAuthorized
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let gitHub: GitHub = GitHub()
    
    static var previews: some View {
        ContentView().environmentObject(gitHub)
    }
}
