//
//  LoadingView.swift
//  GitSwiftly
//
//  Created by jfeigel on 11/16/19.
//  Copyright © 2019 jfeigel. All rights reserved.
//

import SwiftUI

struct LoadingView<Content>: View where Content: View {
    @Binding var isLoading: Bool
    var content: () -> Content
    
    var body: some View {
        GeometryReader{ geometry in
            ZStack(alignment: .center) {
                self.content()
                    .disabled(self.isLoading)
                Group {
                    Color(UIColor.systemBackground.withAlphaComponent(0.1))
                        .colorInvert()
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        ActivityIndicatorView(isAnimating: .constant(true), style: .large)
                    }
                    .frame(width: 50, height: 50)
                }
                .opacity(self.isLoading ? 1 : 0)
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    @State static var isLoading: Bool = true
    static var previews: some View {
        LoadingView(isLoading: $isLoading) {
            Text("Hello World")
        }
    }
}
