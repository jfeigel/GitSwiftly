//
//  RepositoryView.swift
//  GitSwiftly
//
//  Created by jfeigel on 11/11/19.
//  Copyright © 2019 jfeigel. All rights reserved.
//

import SwiftUI
import Down

struct RepositoryView: View {
    @EnvironmentObject var gitHub: GitHub
    
    @State private var showWebView = false
    
    var repo: Repository
    
    var body: some View {
        VStack {
            Text(repo.description ?? "")
                .font(.headline)
                .padding(.bottom, 30)
            HStack {
                Text("View On Github")
                Image(systemName: "safari")
            }
            .onTapGesture(count: 1, perform: { self.showWebView = true })
            ScrollView(.vertical, showsIndicators: true) {
                if (repo.upperReadme?.text ?? "").count > 0 {
                    UIDownView(markdownString: repo.upperReadme!.text)
                        .padding()
                        .border(Color.blue)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
//                        Text(repo.upperReadme!.text)
//                            .fixedSize(horizontal: false, vertical: true)
                } else if (repo.lowerReadme?.text ?? "").count > 0 {
                    UIDownView(markdownString: repo.lowerReadme!.text)
                        .padding()
                        .border(Color.blue)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
//                        Text(repo.lowerReadme!.text)
//                            .fixedSize(horizontal: false, vertical: true)
                } else {
                    Text("nunya")
                }
            }
            .padding()
            .border(Color.black)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        }
        .navigationBarTitle(Text(self.repo.name), displayMode: .large)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .sheet(isPresented: $showWebView, onDismiss: { self.showWebView = false }) {
            NavigationView {
                if (self.repo.upperReadme?.text ?? "").count > 0 {
                    UIDownView(markdownString: self.repo.upperReadme!.text)
                                        .padding()
                                        .border(Color.blue)
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                //                        Text(repo.upperReadme!.text)
                //                            .fixedSize(horizontal: false, vertical: true)
                } else if (self.repo.lowerReadme?.text ?? "").count > 0 {
                    UIDownView(markdownString: self.repo.lowerReadme!.text)
                                        .padding()
                                        .border(Color.blue)
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                //                        Text(repo.lowerReadme!.text)
                //                            .fixedSize(horizontal: false, vertical: true)
                                } else {
                                    Text("nunya")
                                }
            }
        }
        .padding(15)
    }
}

struct RepositoryView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryView(repo: Repository(description: "description", id: "0", name: "title", url: "https://www.github.com", primaryLanguage: Repository.PrimaryLanguage(color: "#ffffff", id: "0", name: "javascript"), stargazers: Repository.Stargazers(totalCount: 1), upperReadme: Repository.Readme(text: ""), lowerReadme: Repository.Readme(text: "")))
    }
}
