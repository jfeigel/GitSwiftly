//
//  ContentView.swift
//  GitSwiftly
//
//  Created by jfeigel on 10/29/19.
//  Copyright © 2019 jfeigel. All rights reserved.
//

import UIKit
import SwiftUI
import AuthenticationServices
import struct Kingfisher.KFImage

struct ContentView: View {
    @EnvironmentObject var gitHub: GitHub
    
    @State private var alert: Alert?
    @State private var isLoading: Bool = false
    @State private var isLoggingIn: Bool = false
    @State private var showAlert: Bool = false
    @State private var showSettingsView: Bool = false
    @State private var showAsList: Bool = true
    @State private var showSheet: Bool = false
    
    var body: some View {
        LoadingView(isLoading: self.$isLoading) {
            NavigationView {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Repositories")
                            .bold()
                        Spacer()
                        HStack(spacing: 0) {
                            Image(systemName: "square.grid.2x2.fill")
                                .font(.system(size: 20))
                                .frame(width: 40, height: 40)
                            Toggle(isOn: self.$showAsList) {
                                Text("")
                            }
                            .labelsHidden()
                            Image(systemName: "list.bullet")
                                .font(.system(size: 20))
                                .frame(width: 40, height: 40)
                        }
                        .disabled((self.gitHub.repos ?? []).count == 0)
                    }
                    .padding(.leading, 10)
                    .background(Color(UIColor.systemGray6))
                    if (self.gitHub.repos ?? []).count > 0 {
                        if self.showAsList {
                            ContentView.RepositoryListView(repos: self.gitHub.repos!)
                        } else {
                            ContentView.RepositoryGridView(repos: self.gitHub.repos!)
                        }
                    } else {
                        VStack(alignment: .leading) {
                            Text("No Repositories found")
                                .padding(.top, 10)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .navigationBarTitle(Text("GitSwiftly"))
                .navigationBarItems(leading:
                    Button(action: { self.showSettingsView = true }) {
                        Image(systemName: "gear")
                            .frame(width: 40, height: 40)
                    }, trailing:
                    NavigationLink(destination: UserView().environmentObject(self.gitHub)) {
                        KFImage(URL(string: self.gitHub.user?.avatarUrl ?? ""))
                            .placeholder() {
                                Image(systemName: "person.circle")
                                    .font(.system(size: 20))
                                    .frame(width: 40, height: 40)
                            }
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .onLongPressGesture(perform: {
                                if let rootVC = UIApplication.shared.windows[0].rootViewController {
                                    let alertHC = UIHostingController(rootView: CustomAlertView(rootVC: rootVC))

                                    alertHC.preferredContentSize = CGSize(width: 300, height: 200)
                                    alertHC.title = "Custom Alert"
                                    alertHC.modalPresentationStyle = .formSheet

                                    rootVC.present(alertHC, animated: true)
                                }
                            })
                    }
                    .buttonStyle(PlainButtonStyle())
                )
            }
            .alert(isPresented: self.$showAlert, content: { self.alert! })
            .sheet(isPresented: self.$showSettingsView, content: { SettingsView() })
//            .onAppear(perform: { if !self.isLoggingIn { self.checkIsAuthorized(reset: false) } })
        }
    }
    
    private func login() {
        gitHub.login() {
            (error) in
            if error != nil {
                self.alert = Alert(title: Text("Error"), message: Text(error!.localizedDescription))
                self.showAlert = true
            } else {
                self.isLoggingIn = false
                self.checkIsAuthorized(reset: false)
            }
        }
    }
    
    private func checkIsAuthorized(reset: Bool = false) {
        if reset {
            self.gitHub.gdModule.oauth2Session.clearTokens()
        }
        gitHub.isAuthorized() {
            (isAuthorized, error) in
            if error != nil {
                self.alert = Alert(title: Text("Error"), message: Text(error!.localizedDescription))
                self.showAlert = true
            } else {
                if !isAuthorized {
                    self.isLoggingIn = true
                    self.login()
                } else {
                    self.isLoading = false
                }
            }
        }
    }
    
    private struct RepositoryListView: View {
        var repos: [Repository]
        
        var body: some View {
            List {
                ForEach(0 ..< self.repos.count) { index in
                    NavigationLink(destination: RepositoryView(repo: self.repos[index])) {
                        RepositoryItemListView(repo: self.repos[index])
                    }
                }
            }
        }
    }

    private struct RepositoryGridView: View {
        var repos: [Repository]
        
        var body: some View {
            GeometryReader { g in
                ScrollView {
                    ForEach(0 ..< self.repos.count / 2) { row in
                        HStack {
                            ForEach(0 ..< 2) { column in
                                NavigationLink(destination: RepositoryView(repo: self.getRepo(row: row, column: column))) {
                                    RepositoryItemGridView(repo: self.getRepo(row: row, column: column), dimension: (g.size.width - 70) / 2)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
            }
        }
        
        private func getRepo(row: Int, column: Int) -> Repository {
            return self.repos[row * 2 + column]
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let gitHub: GitHub = GitHub()
    
    static var previews: some View {
        ContentView().environmentObject(gitHub)
    }
}
