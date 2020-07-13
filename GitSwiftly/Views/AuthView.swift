//
//  AuthView.swift
//  GitSwiftly
//
//  Created by jfeigel on 11/12/19.
//  Copyright © 2019 jfeigel. All rights reserved.
//

import SwiftUI
import OAuthSwift
import AuthenticationServices

final class AuthView: NSObject, View {
    private var authSession: ASWebAuthenticationSession?
    private let presentingWindow: UIWindow
    private let callbackURL: String
    
    var body: some View {
        Text("Auth View")
    }
    
    init(window: UIWindow, callbackURL: String) {
        self.presentingWindow = window
        self.callbackURL = callbackURL
        print("Setting presentingWindow to:", window)
        print("Setting callbackURL to:", callbackURL)
    }
}

extension AuthView: OAuthSwiftURLHandlerType {
    func handle(_ url: URL) {
        print("Handing OAuthSwiftURLHandlerType:", url.absoluteString)
        if authSession != nil {
            print("authSession in progress")
            authSession?.cancel()
            authSession = nil
        }
        
        print("Creating new authSession")
        
        authSession = .init(url: url, callbackURLScheme: callbackURL, completionHandler: { (url, error) in
            if error != nil {
                print("ERROR in AuthSession:", error as Any)
            } else {
                print("SUCCESS in AuthSession:", url as Any)
            }
        })
        
        authSession?.presentationContextProvider = self
        authSession?.start()
    }
}

extension AuthView: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        print("presentationAnchor:", presentingWindow)
        return presentingWindow
    }
}

//struct AuthView_Previews: PreviewProvider {
//    static var previews: some View {
//        AuthView()
//    }
//}
