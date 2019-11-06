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
    @Published var repos: [Repo]?
    @Published var loading: Bool = false {
        didSet {
            if oldValue == false && loading == true {
                print("Refreshing data...")
                self.refresh()
            }
        }
    }
    
    init() {
        self.http = Http(baseURL: "https://api.github.com")
        self.githubConfig = Config(base: "", authzEndpoint: "https://github.com/login/oauth/authorize", redirectURL: "\(Bundle.main.bundleIdentifier!)://oauth2Callback", accessTokenEndpoint: "https://github.com/login/oauth/access_token", clientId: "cedcb77b01d605d8626b", userInfoEndpoint: "https://api.github.com/user", scopes: ["repo", "user"], clientSecret: "0afd81c483d727ddd468c68da8eaed130858d525")
        self.requestSerializer = HttpRequestSerializer()
        self.gdModule = OAuth2Module.init(config: self.githubConfig, requestSerializer: self.requestSerializer)
        self.http.authzModule = gdModule
    }
    
    func refresh() {
        self.requestJson(method: .get, path: "/user") {
            (response, error) in
            print(response)
            if error == nil {
                do {
                    print("decoding user data")
                    self.user = try JSONDecoder().decode(User.self, from: response as! Data)
                    print("user data decoded")
                } catch let decodeError {
                    print("ERROR:", decodeError)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                    print("ending loading")
                    self.loading = false
                }
            }
        }
    }
    
    func isAuthorized(_ completionHandler: @escaping (Bool, NSError?) -> Void) {
        if self.gdModule.isAuthorized() {
            if user == nil {
                self.requestJson(method: .get, path: "/user") {
                    (response, error) in
                    if error != nil {
                        completionHandler(false, error)
                    } else {
                        do {
                            self.user = try JSONDecoder().decode(User.self, from: response as! Data)
                            self.requestJson(method: .get, path: "/users/\(self.user!.login)/repos") {
                                (reposResponse, reposError) in
                                do {
                                    self.repos = try JSONDecoder().decode([Repo].self, from: reposResponse as! Data)
                                } catch let reposDecodeError {
                                    print("ERROR:", reposDecodeError)
                                }
                            }
                            completionHandler(true, nil)
                        } catch let decodeError {
                            completionHandler(false, decodeError as NSError)
                        }
                    }
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
                self.requestJson(method: .get, path: "/user") {
                    (userResponse, userError) in
                    if userError != nil {
                        completionHandler(nil, nil, userError)
                    } else {
                        do {
                            self.user = try JSONDecoder().decode(User.self, from: userResponse as! Data)
                            completionHandler(response, claims, error)
                        } catch let decodeError {
                            completionHandler(nil, nil, decodeError as NSError)
                        }
                    }
                }
            }
        }
    }
    
    private func requestJson(method: HttpMethod, path: String, _ completionHandler: @escaping CompletionBlock) {
        self.requestSerializer.headers = ["Accept": "application/json"]
        self.http.request(method: method, path: path) {
            (response, error) in
            if error == nil {
                do {
                    let data = try JSONSerialization.data(withJSONObject: response!, options: .fragmentsAllowed)
                    completionHandler(data, nil)
                } catch let serializeError {
                    completionHandler(nil, serializeError as NSError)
                }
            } else {
                completionHandler(nil, error)
            }
        }
    }
}
