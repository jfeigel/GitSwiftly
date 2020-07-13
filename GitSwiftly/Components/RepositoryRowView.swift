//
//  RepositoryRowView.swift
//  GitSwiftly
//
//  Created by jfeigel on 11/2/19.
//  Copyright © 2019 jfeigel. All rights reserved.
//

import SwiftUI

struct RepositoryRowView: View {
    @EnvironmentObject var gitHub: GitHub
    
    var repos: [Repository]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack(alignment: .top, spacing: -15) {
                ForEach(self.repos) { repo in
                    NavigationLink(destination: RepositoryView(repo: repo).environmentObject(self.gitHub)) {
                        RepositoryItemGridView(repo: repo)
                            .border(Color(UIColor.systemGray5), width: 1)
                            .cornerRadius(5)
                            .clipped()
                            .padding(15)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .frame(height: 233)
    }
}

struct RepositoryItemGridView: View {
    var repo: Repository
    var dimension: CGFloat? = 180
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(repo.name)
                .font(.headline)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
            Text(repo.description ?? "")
                .font(.footnote)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
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
        .frame(width: dimension, height: dimension)
        .padding(10)
        .background(Color(UIColor.systemGray6))
    }
}

struct RepositoryItemListView: View {
    var repo: Repository
    
    var body: some View {
        HStack {
            Devicon((repo.primaryLanguage.name).lowercased(), size: 20)
                .frame(width: 40, height: 40)
                .background(Color(hex: repo.primaryLanguage.color))
                .foregroundColor(Color(UIColor.black))
                .clipShape(Circle())
            Text(repo.name)
            Spacer()
            HStack {
                Image(systemName: "star.fill")
                Text("\(repo.stargazers.totalCount)")
            }
            .font(.system(size: 14))
        }
    }
}

struct RepositoryRowView_Previews: PreviewProvider {
    static var gitHub: GitHub = GitHub()
    
    static var previews: some View {
        List {
            RepositoryRowView(repos: [
                Repository(description: "description", id: "0", name: "title", url: "https://www.github.com", primaryLanguage: Repository.PrimaryLanguage(color: "#ffffff", id: "0", name: "javascript"), stargazers: Repository.Stargazers(totalCount: 1), upperReadme: Repository.Readme(text: ""), lowerReadme: Repository.Readme(text: "")),
                Repository(description: "description", id: "1", name: "title", url: "https://www.github.com", primaryLanguage: Repository.PrimaryLanguage(color: "#000000", id: "0", name: "typescript"), stargazers: Repository.Stargazers(totalCount: 10), upperReadme: Repository.Readme(text: ""), lowerReadme: Repository.Readme(text: "")),
                Repository(description: "description", id: "2", name: "title", url: "https://www.github.com", primaryLanguage: Repository.PrimaryLanguage(color: "#888888", id: "0", name: "shell"), stargazers: Repository.Stargazers(totalCount: 5), upperReadme: Repository.Readme(text: ""), lowerReadme: Repository.Readme(text: ""))
            ])
        }
        .environment(\.colorScheme, .dark)
        .environmentObject(gitHub)
    }
}
