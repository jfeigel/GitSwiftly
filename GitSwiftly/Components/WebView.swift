//
//  WebView.swift
//  GitSwiftly
//
//  Created by jfeigel on 11/11/19.
//  Copyright © 2019 jfeigel. All rights reserved.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var url: String
    
    init(url: String = "https://www.apple.com") {
        self.url = url
    }
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView()
    }
}
