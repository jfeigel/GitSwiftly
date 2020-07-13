//
//  UIDownView.swift
//  GitSwiftly
//
//  Created by jfeigel on 2/9/20.
//  Copyright © 2020 jfeigel. All rights reserved.
//

import SwiftUI
import WebKit
import Down

struct UIDownView: UIViewRepresentable {
    var markdownString: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let down = Down(markdownString: markdownString)
        let htmlString = (try? down.toHTML()) ?? ""
        let output = "<html><body>\(htmlString)</body></html>"
        uiView.loadHTMLString(htmlString, baseURL: Bundle.main.bundleURL)
    }
}
