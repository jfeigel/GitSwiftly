//
//  RepositoryView.swift
//  GitSwiftly
//
//  Created by jfeigel on 11/11/19.
//  Copyright © 2019 jfeigel. All rights reserved.
//

import SwiftUI

struct RepositoryView: View {
    @EnvironmentObject var gitHub: GitHub
    
    @State private var showWebView = false
    
    var repo: Repository
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(repo.description ?? "")
                .font(.headline)
                .padding(.bottom, 30)
            HStack {
                Text("View On Github")
                Image(systemName: "safari")
            }
            .onTapGesture(count: 1, perform: { self.showWebView = true })
        }
        .navigationBarTitle(Text(self.repo.name), displayMode: .large)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .sheet(isPresented: $showWebView, onDismiss: { self.showWebView = false }) {
            NavigationView {
                WebView(url: self.repo.url)
                    .navigationBarTitle(Text(self.repo.name), displayMode: .inline)
                    .navigationBarItems(leading:
                        Button(action: {
                            self.showWebView = false
                        }) {
                            Text("Done")
                        }
                    )
            }
        }
        .padding(15)
    }
}

struct RepositoryView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryView(repo: Repository(description: "description", id: "0", name: "title", url: "https://www.github.com", primaryLanguage: Repository.PrimaryLanguage(color: "#ffffff", id: "0", name: "javascript"), stargazers: Repository.Stargazers(totalCount: 1)))
    }
}
