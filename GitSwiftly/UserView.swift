//
//  UserView.swift
//  GitSwiftly
//
//  Created by jfeigel on 10/29/19.
//  Copyright © 2019 jfeigel. All rights reserved.
//

import SwiftUI

struct UserView: View {
    @EnvironmentObject var env: Env
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(env.gitHub.user!.name)
                .font(.title)
                .onAppear(perform: { print(self.env.gitHub.user!) })
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
