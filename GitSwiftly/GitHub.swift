//
//  GitHub.swift
//  GitSwiftly
//
//  Created by jfeigel on 10/29/19.
//  Copyright © 2019 jfeigel. All rights reserved.
//

import Foundation
import Combine
import AeroGearHttp
import AeroGearOAuth2

class GitHub: ObservableObject {
    var http: Http
    var githubConfig: Config
    var requestSerializer: HttpRequestSerializer
    var gdModule: OAuth2Module
    
    @Published var user: User?
    
    init() {
        self.http = Http(baseURL: "https://api.github.com")
        self.githubConfig = Config(base: "", authzEndpoint: "https://github.com/login/oauth/authorize", redirectURL: "\(Bundle.main.bundleIdentifier!)://oauth2Callback", accessTokenEndpoint: "https://github.com/login/oauth/access_token", clientId: "cedcb77b01d605d8626b", userInfoEndpoint: "https://api.github.com/user", scopes: ["repo", "user"], clientSecret: "0afd81c483d727ddd468c68da8eaed130858d525")
        self.requestSerializer = HttpRequestSerializer()
        self.gdModule = OAuth2Module.init(config: self.githubConfig, requestSerializer: self.requestSerializer)
        self.http.authzModule = gdModule
    }
    
    func isAuthorized(_ completionHandler: @escaping (Bool, NSError?) -> Void) {
        if self.gdModule.isAuthorized() {
            if user == nil {
                self.getUser() {
                    (response, error) in
                    completionHandler(true, error)
                }
            } else {
                completionHandler(true, nil)
            }
        } else {
            completionHandler(false, nil)
        }
    }
    
    func login(_ completionHandler: @escaping (AnyObject?, OpenIdClaim?, NSError?) -> Void) {
        self.requestSerializer.headers = ["Accept": "application/json"]
        self.gdModule.login() {
            (response, claims, error) in
            if error != nil {
                completionHandler(nil, nil, error)
            } else {
                self.getUser() {
                    (userResponse, userError) in
                    if userError != nil {
                        completionHandler(nil, nil, userError)
                    } else {
                        completionHandler(response, claims, error)
                    }
                }
            }
        }
    }
    
    private func getUser(_ completionHandler: @escaping CompletionBlock) {
        self.http.request(method: .get, path: "/user") {
            (response, error) in
            if error == nil {
                do {
                    let data = try JSONSerialization.data(withJSONObject: response!, options: .fragmentsAllowed)
                    self.user = try JSONDecoder().decode(User.self, from: data)
                    completionHandler(self.user, nil)
                } catch let decodeError {
                    completionHandler(nil, decodeError as NSError)
                }
            } else {
                completionHandler(nil, error)
            }
        }
    }
}
