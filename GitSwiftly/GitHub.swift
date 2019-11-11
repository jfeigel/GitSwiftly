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
    var baseHttp: Http
    var githubConfig: Config
    var requestSerializer: HttpRequestSerializer
    var gdModule: OAuth2Module
    
    @Published var user: User?
    @Published var repos: [Repository]?
    @Published var loading: Bool = false {
        didSet {
            if oldValue == false && loading == true {
                print("Refreshing data...")
                self.refresh()
            }
        }
    }
    
    init() {
        self.baseHttp = Http(baseURL: "https://api.github.com")
        self.githubConfig = Config(base: "", authzEndpoint: "https://github.com/login/oauth/authorize", redirectURL: "\(Bundle.main.bundleIdentifier!)://oauth2Callback", accessTokenEndpoint: "https://github.com/login/oauth/access_token", clientId: "cedcb77b01d605d8626b", userInfoEndpoint: "https://api.github.com/user", scopes: ["repo", "user"], clientSecret: "0afd81c483d727ddd468c68da8eaed130858d525")
        self.requestSerializer = HttpRequestSerializer()
        self.gdModule = OAuth2Module.init(config: self.githubConfig, requestSerializer: self.requestSerializer)
        self.baseHttp.authzModule = gdModule
    }
    
    func refresh() {
        self.requestJson(method: .get, path: "/user") {
            (response, error) in
            if error == nil {
                do {
                    self.user = try JSONDecoder().decode(User.self, from: response as! Data)
                } catch let decodeError {
                    print("ERROR:", decodeError)
                }
                
                self.loading = false
            }
        }
    }
    
    func isAuthorized(_ completionHandler: @escaping (Bool, NSError?) -> Void) {
        if self.gdModule.isAuthorized() {
            if user == nil {
                self.gqlRequest(body: ["query": """
                    query {\
                        viewer {\
                            avatarUrl\
                            company\
                            id\
                            login\
                            name\
                            url\
                            pinnedRepositories(first: 6) {\
                                nodes {\
                                    id\
                                    name\
                                    description\
                                    url\
                                    primaryLanguage {\
                                        color\
                                        id\
                                        name\
                                    }\
                                    stargazers {\
                                        totalCount\
                                    }\
                                }\
                            }\
                        }\
                    }
                """]) {
                    (response, error) in
                    if error != nil {
                        completionHandler(false, error)
                    }
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted)
                        let decodedData = try JSONDecoder().decode(UserResponse.self, from: jsonData)
                        self.user = decodedData.data.viewer
                        self.repos = decodedData.data.viewer.pinnedRepositories.nodes
                        completionHandler(true, nil)
                    } catch {
                        completionHandler(false, error as NSError)
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
        self.gdModule.login(completionHandler: completionHandler)
//        self.gdModule.login() {
//            (response, claims, error) in
//            if error != nil {
//                completionHandler(nil, nil, error)
//            } else {
//                self.requestJson(method: .get, path: "/user") {
//                    (userResponse, userError) in
//                    if userError != nil {
//                        completionHandler(nil, nil, userError)
//                    } else {
//                        do {
//                            self.user = try JSONDecoder().decode(User.self, from: userResponse as! Data)
//                            completionHandler(response, claims, error)
//                        } catch let decodeError {
//                            completionHandler(nil, nil, decodeError as NSError)
//                        }
//                    }
//                }
//            }
//        }
    }
    
    private func requestJson(method: HttpMethod, path: String, _ completionHandler: @escaping CompletionBlock) {
        self.requestSerializer.headers = ["Accept": "application/json"]
        self.baseHttp.request(method: method, path: path) {
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
    
    private func gqlRequest(body: [String: Any]?, _ completionHandler: @escaping CompletionBlock) {
        self.requestSerializer.headers = ["Accept": "application/json"]
        self.baseHttp.request(method: .post, path: "/graphql", parameters: body, completionHandler: completionHandler)
    }
}
