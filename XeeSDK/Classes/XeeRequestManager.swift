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
    
    public func refreshToken(withRefreshToken refreshToken: String, Scope scope: String, completionHandler: ((_ error: Error?, _ token: XeeToken?) -> Void)? ) {
        
        let parameters: Parameters = ["grant_type":"refresh_token", "scope":scope, "refresh_token":refreshToken]
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
    

}
