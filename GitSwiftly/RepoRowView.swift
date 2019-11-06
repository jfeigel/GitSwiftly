//
//  RepoRowView.swift
//  GitSwiftly
//
//  Created by jfeigel on 11/2/19.
//  Copyright © 2019 jfeigel. All rights reserved.
//

import SwiftUI

struct RepoRowView: View {
    var repo: Repo
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(repo.name)
                Text(repo.description ?? "")
            }
            Spacer()
            Devicon((repo.language ?? "").lowercased(), size: 40)
        }
    }
}

struct RepoRowView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            RepoRowView(repo: Repo(id: 0, name: "title", html_url: "https://www.github.com", description: "description", language: "javascript"))
            RepoRowView(repo: Repo(id: 1, name: "title", html_url: "https://www.github.com", description: "description", language: "typescript"))
            RepoRowView(repo: Repo(id: 2, name: "title", html_url: "https://www.github.com", description: "description", language: "shell"))
        }
    }
}
