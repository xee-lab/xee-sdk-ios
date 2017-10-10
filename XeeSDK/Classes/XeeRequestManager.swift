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
                    }else if let message = user.message, let _ = user.tip, let type = user.type {
                        let apiError: Error = NSError(domain: type, code: NSURLErrorUnknown, userInfo: [NSLocalizedDescriptionKey: message])
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
    
    public func updateUser(WithUser user:XeeUser, completionHandler: ((_ error: Error?, _ vehicle: XeeUser?) -> Void)? ) {
        
        let parameters: Parameters = user.toJSON()
        
        var headers: HTTPHeaders = [:]
        if let accessToken = XeeConnectManager.shared.token?.accessToken {
            headers["Authorization"] = "Bearer " + accessToken
        }
        
        Alamofire.request("\(baseURL!)users/\(user.userID!)", method:.patch, parameters:parameters, encoding:JSONEncoding.default, headers:headers).responseObject { (response: DataResponse<XeeUser>) in
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
                    }else if let message = user.message, let _ = user.tip, let type = user.type {
                        let apiError: Error = NSError(domain: type, code: NSURLErrorUnknown, userInfo: [NSLocalizedDescriptionKey: message])
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
    
    public func getVehicles(WithUserID userId:String?, completionHandler: ((_ error: Error?, _ vehicles: [XeeVehicle]?) -> Void)? ) {
        
        var headers: HTTPHeaders = [:]
        if let accessToken = XeeConnectManager.shared.token?.accessToken {
            headers["Authorization"] = "Bearer " + accessToken
        }
        
        var userIDString: String
        if let userID = userId {
            userIDString = userID
        }else {
            userIDString = "me"
        }
        
        Alamofire.request("\(baseURL!)users/\(userIDString)/vehicles", headers:headers).responseArray { (response: DataResponse<[XeeVehicle]>) in
            if let error = response.error {
                if let completionHandler = completionHandler {
                    completionHandler(error, nil)
                }
            }else {
                if let vehicles = response.result.value {
                    if vehicles.count > 0 {
                        if let completionHandler = completionHandler {
                            completionHandler(nil, vehicles)
                        }
                    }else {
                        let apiError: Error = NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown, userInfo: [NSLocalizedDescriptionKey: "No vehicule"])
                        if let completionHandler = completionHandler {
                            completionHandler(apiError, nil)
                        }
                    }
                }
            }
        }
    }
    
    public func getVehicle(WithVehicleID vehicleId:String, completionHandler: ((_ error: Error?, _ vehicle: XeeVehicle?) -> Void)? ) {
        
        var headers: HTTPHeaders = [:]
        if let accessToken = XeeConnectManager.shared.token?.accessToken {
            headers["Authorization"] = "Bearer " + accessToken
        }
        
        Alamofire.request("\(baseURL!)vehicles/\(vehicleId)", headers:headers).responseObject { (response: DataResponse<XeeVehicle>) in
            if let error = response.error {
                if let completionHandler = completionHandler {
                    completionHandler(error, nil)
                }
            }else {
                if let vehicle = response.result.value {
                    if let error = vehicle.error, let errorMessage = vehicle.errorMessage {
                        let apiError: Error = NSError(domain: error, code: NSURLErrorUnknown, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                        if let completionHandler = completionHandler {
                            completionHandler(apiError, nil)
                        }
                    }else if let message = vehicle.message, let _ = vehicle.tip, let type = vehicle.type {
                        let apiError: Error = NSError(domain: type, code: NSURLErrorUnknown, userInfo: [NSLocalizedDescriptionKey: message])
                        if let completionHandler = completionHandler {
                            completionHandler(apiError, nil)
                        }
                    }else {
                        if let completionHandler = completionHandler {
                            completionHandler(nil, vehicle)
                        }
                    }
                }
            }
        }
    }
    
    public func getStatus(WithVehicleID vehicleId:String, completionHandler: ((_ error: Error?, _ status: XeeStatus?) -> Void)? ) {
        
        var headers: HTTPHeaders = [:]
        if let accessToken = XeeConnectManager.shared.token?.accessToken {
            headers["Authorization"] = "Bearer " + accessToken
        }
        
        Alamofire.request("\(baseURL!)vehicles/\(vehicleId)/status", headers:headers).responseObject { (response: DataResponse<XeeStatus>) in
            if let error = response.error {
                if let completionHandler = completionHandler {
                    completionHandler(error, nil)
                }
            }else {
                if let status = response.result.value {
                    if let error = status.error, let errorMessage = status.errorMessage {
                        let apiError: Error = NSError(domain: error, code: NSURLErrorUnknown, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                        if let completionHandler = completionHandler {
                            completionHandler(apiError, nil)
                        }
                    }else if let message = status.message, let _ = status.tip, let type = status.type {
                        let apiError: Error = NSError(domain: type, code: NSURLErrorUnknown, userInfo: [NSLocalizedDescriptionKey: message])
                        if let completionHandler = completionHandler {
                            completionHandler(apiError, nil)
                        }
                    }else {
                        if let completionHandler = completionHandler {
                            completionHandler(nil, status)
                        }
                    }
                }
            }
        }
    }
    
    public func updateVehicle(WithVehicle vehicle:XeeVehicle, completionHandler: ((_ error: Error?, _ vehicle: XeeVehicle?) -> Void)? ) {
        
        let parameters: Parameters = vehicle.toJSON()
        
        var headers: HTTPHeaders = [:]
        if let accessToken = XeeConnectManager.shared.token?.accessToken {
            headers["Authorization"] = "Bearer " + accessToken
        }
        
        Alamofire.request("\(baseURL!)vehicles/\(vehicle.vehiculeID!)", method:.patch, parameters:parameters, encoding:JSONEncoding.default, headers:headers).responseObject { (response: DataResponse<XeeVehicle>) in
            if let error = response.error {
                if let completionHandler = completionHandler {
                    completionHandler(error, nil)
                }
            }else {
                if let vehicle = response.result.value {
                    if let error = vehicle.error, let errorMessage = vehicle.errorMessage {
                        let apiError: Error = NSError(domain: error, code: NSURLErrorUnknown, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                        if let completionHandler = completionHandler {
                            completionHandler(apiError, nil)
                        }
                    }else if let message = vehicle.message, let _ = vehicle.tip, let type = vehicle.type {
                        let apiError: Error = NSError(domain: type, code: NSURLErrorUnknown, userInfo: [NSLocalizedDescriptionKey: message])
                        if let completionHandler = completionHandler {
                            completionHandler(apiError, nil)
                        }
                    }else {
                        if let completionHandler = completionHandler {
                            completionHandler(nil, vehicle)
                        }
                    }
                }
            }
        }
    }
    
    public func getDevice(ForVehicleID vehicleId:String, completionHandler: ((_ error: Error?, _ vehicle: XeeDevice?) -> Void)? ) {
        
        var headers: HTTPHeaders = [:]
        if let accessToken = XeeConnectManager.shared.token?.accessToken {
            headers["Authorization"] = "Bearer " + accessToken
        }
        
        Alamofire.request("\(baseURL!)vehicles/\(vehicleId)/device", headers:headers).responseObject { (response: DataResponse<XeeDevice>) in
            if let error = response.error {
                if let completionHandler = completionHandler {
                    completionHandler(error, nil)
                }
            }else {
                if let device = response.result.value {
                    if let error = device.error, let errorMessage = device.errorMessage {
                        let apiError: Error = NSError(domain: error, code: NSURLErrorUnknown, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                        if let completionHandler = completionHandler {
                            completionHandler(apiError, nil)
                        }
                    }else if let message = device.message, let _ = device.tip, let type = device.type {
                        let apiError: Error = NSError(domain: type, code: NSURLErrorUnknown, userInfo: [NSLocalizedDescriptionKey: message])
                        if let completionHandler = completionHandler {
                            completionHandler(apiError, nil)
                        }
                    }else {
                        if let completionHandler = completionHandler {
                            completionHandler(nil, device)
                        }
                    }
                }
            }
        }
    }
    
    public func getPrivacies(ForVehicleID vehicleId:String, From from:Date?, To to:Date?, Limit limit:Int?, completionHandler: ((_ error: Error?, _ privacies: [XeePrivacy]?) -> Void)? ) {
        
        var parameters: Parameters = [:]
        if let from = from {
            parameters["from"] = from.iso8601
        }
        if let to = to {
            parameters["to"] = to.iso8601
        }
        if let limit = limit {
            parameters["limit"] = limit
        }
        
        var headers: HTTPHeaders = [:]
        if let accessToken = XeeConnectManager.shared.token?.accessToken {
            headers["Authorization"] = "Bearer " + accessToken
        }
        
        Alamofire.request("\(baseURL!)vehicles/\(vehicleId)/privacies", parameters:parameters, headers:headers).responseArray { (response: DataResponse<[XeePrivacy]>) in
            if let error = response.error {
                if let completionHandler = completionHandler {
                    completionHandler(error, nil)
                }
            }else {
                if let privacies = response.result.value {
                    if privacies.count > 0 {
                        if let completionHandler = completionHandler {
                            completionHandler(nil, privacies)
                        }
                    }else {
                        let apiError: Error = NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown, userInfo: [NSLocalizedDescriptionKey: "No privacy"])
                        if let completionHandler = completionHandler {
                            completionHandler(apiError, nil)
                        }
                    }
                }
            }
        }
    }
    
    public func startPrivacy(ForVehicleID vehicleId:String, completionHandler: ((_ error: Error?, _ privacy: XeePrivacy?) -> Void)? ) {
        
        var headers: HTTPHeaders = [:]
        if let accessToken = XeeConnectManager.shared.token?.accessToken {
            headers["Authorization"] = "Bearer " + accessToken
        }
        
        Alamofire.request("\(baseURL!)vehicles/\(vehicleId)/privacies", method:.post, headers:headers).responseObject { (response: DataResponse<XeePrivacy>) in
            if let error = response.error {
                if let completionHandler = completionHandler {
                    completionHandler(error, nil)
                }
            }else {
                if let privacy = response.result.value {
                    if let error = privacy.error, let errorMessage = privacy.errorMessage {
                        let apiError: Error = NSError(domain: error, code: NSURLErrorUnknown, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                        if let completionHandler = completionHandler {
                            completionHandler(apiError, nil)
                        }
                    }else if let message = privacy.message, let _ = privacy.tip, let type = privacy.type {
                        let apiError: Error = NSError(domain: type, code: NSURLErrorUnknown, userInfo: [NSLocalizedDescriptionKey: message])
                        if let completionHandler = completionHandler {
                            completionHandler(apiError, nil)
                        }
                    }else {
                        if let completionHandler = completionHandler {
                            completionHandler(nil, privacy)
                        }
                    }
                }
            }
        }
    }
    
    public func stopPrivacy(ForVPrivacyID privacyID:String, completionHandler: ((_ error: Error?, _ privacy: XeePrivacy?) -> Void)? ) {
        
        var headers: HTTPHeaders = [:]
        if let accessToken = XeeConnectManager.shared.token?.accessToken {
            headers["Authorization"] = "Bearer " + accessToken
        }
        
        Alamofire.request("\(baseURL!)privacies/\(privacyID)", method:.put, headers:headers).responseObject { (response: DataResponse<XeePrivacy>) in
            if let error = response.error {
                if let completionHandler = completionHandler {
                    completionHandler(error, nil)
                }
            }else {
                if let privacy = response.result.value {
                    if let error = privacy.error, let errorMessage = privacy.errorMessage {
                        let apiError: Error = NSError(domain: error, code: NSURLErrorUnknown, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                        if let completionHandler = completionHandler {
                            completionHandler(apiError, nil)
                        }
                    }else if let message = privacy.message, let _ = privacy.tip, let type = privacy.type {
                        let apiError: Error = NSError(domain: type, code: NSURLErrorUnknown, userInfo: [NSLocalizedDescriptionKey: message])
                        if let completionHandler = completionHandler {
                            completionHandler(apiError, nil)
                        }
                    }else {
                        if let completionHandler = completionHandler {
                            completionHandler(nil, privacy)
                        }
                    }
                }
            }
        }
    }
    

}
