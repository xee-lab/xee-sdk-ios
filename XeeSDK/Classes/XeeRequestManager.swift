//
//  XeeRequestManager.swift
//  XeeSDK
//
//  Created by Jean-Baptiste Dujardin on 03/10/2017.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

public class XeeRequestManager {
    
    private init() {}
    public static let shared = XeeRequestManager()
    
    var baseURL: URL? {
        get {
            if let baseURL = XeeConnectManager.shared.baseURL {
                return baseURL
            }else {
                return nil
            }
        }
    }
    
    var clientID: String? {
        get {
            if let clientID = XeeConnectManager.shared.config?.clientID {
                return clientID
            }else {
                return nil
            }
        }
    }
    
    var secretKey: String? {
        get {
            if let secretKey = XeeConnectManager.shared.config?.secretKey {
                return secretKey
            }else {
                return nil
            }
        }
    }
    
    var scope: String? {
        get {
            if let scope = XeeConnectManager.shared.token?.scope {
                return scope
            }else {
                return nil
            }
        }
    }
    
    public func getToken(withCode code: String, completionHandler: ((_ error: Error?, _ token: XeeToken?) -> Void)? ) {
        
        let parameters: Parameters = ["grant_type":"authorization_code", "code":code]
        var headers: HTTPHeaders = [:]
        
        if let authorizationHeader = Request.authorizationHeader(user: clientID!, password: secretKey!) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        Alamofire.request("\(baseURL!)" + "/oauth/token", method:.post, parameters:parameters, encoding:URLEncoding.default, headers:headers).responseObject { (response: DataResponse<XeeToken>) in
            if let error = response.error {
                UserDefaults.standard.set(nil, forKey: "XeeSDKInternalAccessToken")
                UserDefaults.standard.synchronize()
                if let completionHandler = completionHandler {
                    completionHandler(error, nil)
                }
            }else {
                if let token = response.result.value {
                    if let error = token.error, let errorMessage = token.errorMessage {
                        let apiError: Error = NSError(domain: error, code: NSURLErrorUnknown, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                        UserDefaults.standard.set(nil, forKey: "XeeSDKInternalAccessToken")
                        UserDefaults.standard.synchronize()
                        if let completionHandler = completionHandler {
                            completionHandler(apiError, nil)
                        }
                    }else {
                        UserDefaults.standard.set(token.toJSON(), forKey: "XeeSDKInternalAccessToken")
                        UserDefaults.standard.synchronize()
                        if let completionHandler = completionHandler {
                            completionHandler(nil, token)
                        }
                    }
                }
            }
        }
    }
    
    public func refreshToken(completionHandler: ((_ error: Error?, _ token: XeeToken?) -> Void)? ) {
        
        var parameters: Parameters = ["grant_type":"refresh_token"]
        if let refreshToken = XeeConnectManager.shared.token?.refreshToken {
            parameters["refresh_token"] = refreshToken
        }
        if let scope = XeeConnectManager.shared.token?.scope {
            parameters["scope"] = scope
        }
        
        var headers: HTTPHeaders = [:]
        
        if let authorizationHeader = Request.authorizationHeader(user: clientID!, password: secretKey!) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        Alamofire.request("\(baseURL!)" + "/oauth/token", method:.post, parameters:parameters, encoding:URLEncoding.default, headers:headers).responseObject { (response: DataResponse<XeeToken>) in
            if let error = response.error {
                UserDefaults.standard.set(nil, forKey: "XeeSDKInternalAccessToken")
                UserDefaults.standard.synchronize()
                if let completionHandler = completionHandler {
                    completionHandler(error, nil)
                }
            }else {
                if let token = response.result.value {
                    if let error = token.error, let errorMessage = token.errorMessage {
                        let apiError: Error = NSError(domain: error, code: NSURLErrorUnknown, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                        UserDefaults.standard.set(nil, forKey: "XeeSDKInternalAccessToken")
                        UserDefaults.standard.synchronize()
                        if let completionHandler = completionHandler {
                            completionHandler(apiError, nil)
                        }
                    }else {
                        UserDefaults.standard.set(token.toJSON(), forKey: "XeeSDKInternalAccessToken")
                        UserDefaults.standard.synchronize()
                        if let completionHandler = completionHandler {
                            completionHandler(nil, token)
                        }
                    }
                }
            }
        }
    }
    
    public func getUser(completionHandler: ((_ error: Error?, _ user: XeeUser?) -> Void)? ) {
        
        var headers: HTTPHeaders = [:]
        if let accessToken = XeeConnectManager.shared.token?.accessToken {
            headers["Authorization"] = "Bearer " + accessToken
        }
        
        Alamofire.request("\(baseURL!)" + "/users/me", encoding:URLEncoding.default, headers:headers).responseObject { (response: DataResponse<XeeUser>) in
            if let error = response.error {
                if let completionHandler = completionHandler {
                    completionHandler(error, nil)
                }
            }else {
                if let user = response.result.value {
                    if let error = user.error, let errorMessage = user.errorMessage {
                        let apiError: Error = NSError(domain: error, code: NSURLErrorUnknown, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                        if let completionHandler = completionHandler {
                            completionHandler(apiError, nil)
                        }
                    }else {
                        if let completionHandler = completionHandler {
                            completionHandler(nil, user)
                        }
                    }
                }
            }
        }
    }
    

}
