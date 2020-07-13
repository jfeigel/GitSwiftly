//
//  ActivityIndicatorView.swift
//  GitSwiftly
//
//  Created by jfeigel on 11/14/19.
//  Copyright © 2019 jfeigel. All rights reserved.
//

import SwiftUI
import WebKit

struct ActivityIndicatorView: UIViewRepresentable {
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

struct ActivityIndicatorView_Previews: PreviewProvider {
    @State static var isAnimating: Bool = true
    static var dimensions: CGFloat = 100
    
    static var previews: some View {
        VStack {
            ActivityIndicatorView(isAnimating: $isAnimating, style: .large)
                .frame(width: dimensions, height: dimensions)
        }
    }
}
