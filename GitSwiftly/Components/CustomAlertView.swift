//
//  CustomAlertView.swift
//  GitSwiftly
//
//  Created by jfeigel on 11/20/19.
//  Copyright © 2019 jfeigel. All rights reserved.
//

import SwiftUI

struct CustomAlertView: View {
    var rootVC: UIViewController
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(0 ..< 3) {
                        Text("Item \($0)")
                    }
                }
            }
            .navigationBarTitle(Text("Custom Alert"))
            .navigationBarItems(trailing: Button(action: {
                self.rootVC.dismiss(animated: true, completion: {})
            }) {
                Text("Done")
            })
        }
    }
}

struct CustomAlertView_Previews: PreviewProvider {
    @State static var rootVC = UIApplication.shared.windows[0].rootViewController ?? UIViewController()
    
    static var previews: some View {
        CustomAlertView(rootVC: rootVC)
    }
}
