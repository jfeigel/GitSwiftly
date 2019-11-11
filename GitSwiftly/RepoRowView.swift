//
//  RepoRowView.swift
//  GitSwiftly
//
//  Created by jfeigel on 11/2/19.
//  Copyright © 2019 jfeigel. All rights reserved.
//

import SwiftUI

struct RepoRowView: View {
    @EnvironmentObject var gitHub: GitHub
    
    var repos: [Repository]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: -15) {
                ForEach(self.repos) { repo in
                    NavigationLink(destination: RepositoryView(repo: repo).environmentObject(self.gitHub)) {
                        RepoItemView(repo: repo)
                            .border(Color(UIColor.systemGray5), width: 1)
                            .cornerRadius(5)
                            .clipped()
                            .padding(15)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .frame(height: 200)
    }
}

struct RepoItemView: View {
    var repo: Repository
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(repo.name)
                .font(.headline)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
            Text(repo.description ?? "")
                .font(.footnote)
            Spacer()
            HStack(alignment: .center, spacing: 0) {
                HStack {
                    Image(systemName: "star.fill")
                    Text("\(repo.stargazers.totalCount)")
                        .font(.system(size: 20))
                }
                .padding(10)
                Spacer()
                Devicon((repo.primaryLanguage.name).lowercased(), size: 20)
                    .padding(10)
            }
            .frame(height: 40)
            .background(Color(hex: repo.primaryLanguage.color))
            .padding(-10)
            .foregroundColor(Color(UIColor.black))
        }
        .frame(width: 180, height: 180)
        .padding(10)
        .background(Color(UIColor.systemGray6))
    }
}

struct RepoRowView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            RepoRowView(repos: [
                Repository(description: "description", id: "0", name: "title", url: "https://www.github.com", primaryLanguage: Repository.PrimaryLanguage(color: "#ffffff", id: "0", name: "javascript"), stargazers: Repository.Stargazers(totalCount: 1)),
                Repository(description: "description", id: "1", name: "title", url: "https://www.github.com", primaryLanguage: Repository.PrimaryLanguage(color: "#000000", id: "0", name: "typescript"), stargazers: Repository.Stargazers(totalCount: 10)),
                Repository(description: "description", id: "2", name: "title", url: "https://www.github.com", primaryLanguage: Repository.PrimaryLanguage(color: "#888888", id: "0", name: "shell"), stargazers: Repository.Stargazers(totalCount: 5))
            ])
        }.environment(\.colorScheme, .dark)
    }
}
