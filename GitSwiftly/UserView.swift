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
        ZStack {
            VStack {
                Text("")
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 500, alignment: .topLeading)
            .clipped()
            .background(Color(UIColor.systemBackground))
            .shadow(radius: 10)
            VStack {
                KFImage(URL(string: self.gitHub.user!.avatar_url))
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10)
                    .offset(y: -93.5)
                    .padding(.bottom, -93.5)
                VStack(alignment: .leading) {
                    Text(self.gitHub.user!.name)
                        .font(.title)
                    Text(self.gitHub.user!.login)
                        .font(.headline)
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
                .padding(20)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 500, alignment: .topLeading)
            .background(Color(UIColor.systemBackground))
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .bottom)
        .background(Color(UIColor.systemGray2))
        .clipped()
        .navigationBarTitle("", displayMode: .inline)
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
