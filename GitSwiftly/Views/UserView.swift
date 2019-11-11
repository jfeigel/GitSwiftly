//
//  UserView.swift
//  GitSwiftly
//
//  Created by jfeigel on 10/29/19.
//  Copyright © 2019 jfeigel. All rights reserved.
//

import SwiftUI
import struct Kingfisher.KFImage

struct UserView: View {
    @EnvironmentObject var gitHub: GitHub
    
    var body: some View {
        GeometryReader { metrics in
            ZStack {
                VStack {
                    Text("")
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: metrics.size.height * 0.8, alignment: .topLeading)
                .clipped()
                .background(Color(UIColor.systemBackground))
                .shadow(color: Color(UIColor.systemGray4), radius: 10)
                VStack {
                    KFImage(URL(string: self.gitHub.user!.avatarUrl))
                        .resizable()
                        .frame(width: 128, height: 128)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 10)
                        .offset(y: -62)
                        .padding(.bottom, -62)
                    VStack(alignment: .leading) {
                        Text(self.gitHub.user!.name)
                            .font(.title)
                        Text(self.gitHub.user!.login)
                            .font(.headline)
                        Spacer()
                        Text("Pinned Repositories")
                            .font(.headline)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 15))
                    RepoRowView(repos: self.gitHub.repos!).environmentObject(self.gitHub)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: metrics.size.height * 0.8)
                .background(Color(UIColor.systemBackground))
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .bottom)
            .background(Color(UIColor.systemGray4))
            .clipped()
            .navigationBarTitle("User", displayMode: .inline)
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static let gitHub: GitHub = GitHub()
    
    static var previews: some View {
        UserView().environmentObject(gitHub)
    }
}
