//
//  XeeRequestManager.swift
//  XeeSDK
//
//  Created by Jean-Baptiste Dujardin on 03/10/2017.
//

import Foundation
import Alamofire
import ObjectMapper

public class XeeRequestManager: SessionManager{
    
    private init() {
        super.init(configuration: URLSessionConfiguration.default, delegate: Alamofire.SessionDelegate(), serverTrustPolicyManager: nil)
    }
    
    public static let shared = XeeRequestManager()
    
    var baseURL: URL? {
        if let baseURL = XeeConnectManager.shared.baseURL {
            return baseURL
        }else {
            return nil
        }
    }
    
    var clientID: String? {
        if let clientID = XeeConnectManager.shared.config?.clientID {
            return clientID
        }else {
            return nil
        }
    }
    
    var secretKey: String? {
        if let secretKey = XeeConnectManager.shared.config?.secretKey {
            return secretKey
        }else {
            return nil
        }
    }
    
    var scope: String? {
        if let scope = XeeConnectManager.shared.token?.scope {
            return scope
        }else {
            return nil
        }
    }
    
    private func xeeObjectRequest<T: BaseMappable>(_ url: String,
                                                   method: HTTPMethod = .get,
                                                   parameters: Parameters? = nil,
                                                   encoding: ParameterEncoding = URLEncoding.default,
                                                   headers: HTTPHeaders? = nil,
                                                   objectType _: T.Type,
                                                   completionHandler: ((_ error: Error?, _ object: T?) -> Void)? ) {
        
        self.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseObject { (response: DataResponse<T>) in
            if let error = response.error {
                if error.code == 401 {
                    XeeRequestManager.shared.refreshToken(completionHandler: { (errorRefresh, token) in
                        if errorRefresh != nil {
                            if let completionHandler = completionHandler {
                                completionHandler(errorRefresh, nil)
                            }
                        }else {
                            var headers: HTTPHeaders = [:]
                            if let accessToken = XeeConnectManager.shared.token?.accessToken {
                                headers["Authorization"] = "Bearer " + accessToken
                            }
                            self.xeeObjectRequest(url, method: method, parameters: parameters, encoding: encoding, headers: headers, objectType: T.self, completionHandler: completionHandler)
                        }
                    })
                }else {
                    if let completionHandler = completionHandler {
                        completionHandler(error, nil)
                    }
                }
            }else {
                if let object = response.result.value {
                    if let completionHandler = completionHandler {
                        completionHandler(nil, object)
                    }
                }else {
                    if let completionHandler = completionHandler {
                        completionHandler(nil, nil)
                    }
                }
            }
        }
    }
    
    private func xeeObjectsRequest<T : BaseMappable>(_ url: String,
                                                    method: HTTPMethod = .get,
                                                    parameters: Parameters? = nil,
                                                    encoding: ParameterEncoding = URLEncoding.default,
                                                    headers: HTTPHeaders? = nil,
                                                    objectType _: T.Type,
                                                    completionHandler: ((_ error: Error?, _ objects: [T]?) -> Void)? ) {
        
        self.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseArray { (response: DataResponse<[T]>) in
            if let error = response.error {
                if error.code == 401 {
                    XeeRequestManager.shared.refreshToken(completionHandler: { (errorRefresh, token) in
                        if errorRefresh != nil {
                            if let completionHandler = completionHandler {
                                completionHandler(errorRefresh, nil)
                            }
                        }else {
                            var headers: HTTPHeaders = [:]
                            if let accessToken = XeeConnectManager.shared.token?.accessToken {
                                headers["Authorization"] = "Bearer " + accessToken
                            }
                            self.xeeObjectsRequest(url, method: method, parameters: parameters, encoding: encoding, headers: headers, objectType: T.self, completionHandler: completionHandler)
                        }
                    })
                }else {
                    if let completionHandler = completionHandler {
                        completionHandler(error, nil)
                    }
                }
            }else {
                if let objects = response.result.value {
                    if let completionHandler = completionHandler {
                        completionHandler(nil, objects)
                    }
                }else {
                    if let completionHandler = completionHandler {
                        completionHandler(nil, nil)
                    }
                }
            }
        }
    }
    
    public func getToken(withCode code: String, completionHandler: ((_ error: Error?, _ token: XeeToken?) -> Void)? ) {
        
        let parameters: Parameters = ["grant_type":"authorization_code", "code":code]
        var headers: HTTPHeaders = [:]
        
        if let authorizationHeader = Request.authorizationHeader(user: clientID!, password: secretKey!) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        self.xeeObjectRequest("\(baseURL!)oauth/token", method: HTTPMethod.post, parameters: parameters, encoding: URLEncoding.default, headers: headers, objectType: XeeToken.self) { (error, token) in
            if error != nil {
                UserDefaults.standard.set(nil, forKey: "XeeSDKInternalAccessToken")
                UserDefaults.standard.synchronize()
                if let completionHandler = completionHandler {
                    completionHandler(error, nil)
                }
            }else if let token = token {
                UserDefaults.standard.set(token.toJSON(), forKey: "XeeSDKInternalAccessToken")
                UserDefaults.standard.synchronize()
                if let completionHandler = completionHandler {
                    completionHandler(nil, token)
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
        
        self.xeeObjectRequest("\(baseURL!)oauth/token", method: HTTPMethod.post, parameters: parameters, encoding: URLEncoding.default, headers: headers, objectType: XeeToken.self) { (error, token) in
            if error != nil {
                UserDefaults.standard.set(nil, forKey: "XeeSDKInternalAccessToken")
                UserDefaults.standard.synchronize()
                if let completionHandler = completionHandler {
                    completionHandler(error, nil)
                }
            }else if let token = token {
                UserDefaults.standard.set(token.toJSON(), forKey: "XeeSDKInternalAccessToken")
                UserDefaults.standard.synchronize()
                if let completionHandler = completionHandler {
                    completionHandler(nil, token)
                }
            }
        }
    }
    
    public func revokeToken(completionHandler: ((_ error: Error?) -> Void)? ) {
        
        var headers: HTTPHeaders = [:]
        if let accessToken = XeeConnectManager.shared.token?.accessToken {
            headers["Authorization"] = "Bearer " + accessToken
        }
        
        self.request("\(baseURL!)oauth/revoke", method: .post, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            if let error = response.error {
                if error.code == 401 {
                    XeeRequestManager.shared.refreshToken(completionHandler: { (errorRefresh, token) in
                        self.revokeToken(completionHandler: completionHandler)
                    })
                }else {
                    if let completionHandler = completionHandler {
                        completionHandler(error)
                    }
                }
            }else if let JSONObject = response.result.value as? [String: String] {
                if let type = JSONObject["type"], let message = JSONObject["message"], let tip = JSONObject["tip"] {
                    let errorDomain = type
                    
                    let userInfo = [NSLocalizedFailureReasonErrorKey: message, NSLocalizedRecoverySuggestionErrorKey: tip]
                    let returnError = NSError(domain: errorDomain, code: response.response?.statusCode ?? 0, userInfo: userInfo)
                    if let completionHandler = completionHandler {
                        completionHandler(returnError)
                    }
                }
            }else {
                if let completionHandler = completionHandler {
                    completionHandler(nil)
                }
            }
        }
    }
    
    public func getUser(completionHandler: ((_ error: Error?, _ user: XeeUser?) -> Void)? ) {
        
        var headers: HTTPHeaders = [:]
        if let accessToken = XeeConnectManager.shared.token?.accessToken {
            headers["Authorization"] = "Bearer " + accessToken
        }
        
        self.xeeObjectRequest("\(baseURL!)users/me", method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: headers, objectType: XeeUser.self) { (error, user) in
            if let completionHandler = completionHandler {
                completionHandler(error, user)
            }
        }
    }
    
    public func updateUser(WithUser user:XeeUser, completionHandler: ((_ error: Error?, _ vehicle: XeeUser?) -> Void)? ) {
        
        let parameters: Parameters = user.toJSON()
        
        var headers: HTTPHeaders = [:]
        if let accessToken = XeeConnectManager.shared.token?.accessToken {
            headers["Authorization"] = "Bearer " + accessToken
        }
        
        self.xeeObjectRequest("\(baseURL!)users/\(user.userID!)", method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers, objectType: XeeUser.self) { (error, user) in
            if let completionHandler = completionHandler {
                completionHandler(error, user)
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
        
        self.xeeObjectsRequest("\(baseURL!)users/\(userIDString)/vehicles", headers: headers, objectType: XeeVehicle.self) { (error, vehicles) in
            if let completionHandler = completionHandler {
                completionHandler(error, vehicles)
            }
        }
    }
    
    public func getVehicle(WithVehicleID vehicleId:String, completionHandler: ((_ error: Error?, _ vehicle: XeeVehicle?) -> Void)? ) {
        
        var headers: HTTPHeaders = [:]
        if let accessToken = XeeConnectManager.shared.token?.accessToken {
            headers["Authorization"] = "Bearer " + accessToken
        }
        
        self.xeeObjectRequest("\(baseURL!)vehicles/\(vehicleId)", headers:headers, objectType: XeeVehicle.self) { (error, vehicle) in
            if let completionHandler = completionHandler {
                completionHandler(error, vehicle)
            }
        }
    }
    
    public func getStatus(WithVehicleID vehicleId:String, completionHandler: ((_ error: Error?, _ status: XeeStatus?) -> Void)? ) {
        
        var headers: HTTPHeaders = [:]
        if let accessToken = XeeConnectManager.shared.token?.accessToken {
            headers["Authorization"] = "Bearer " + accessToken
        }
        
        self.xeeObjectRequest("\(baseURL!)vehicles/\(vehicleId)/status", headers:headers, objectType: XeeStatus.self) { (error, status) in
            if let completionHandler = completionHandler {
                completionHandler(error, status)
            }
        }
    }
    
    public func getTrips(WithVehicleID vehicleId:String, completionHandler: ((_ error: Error?, _ trips: [XeeTrip]?) -> Void)? ) {
        
        var headers: HTTPHeaders = [:]
        if let accessToken = XeeConnectManager.shared.token?.accessToken {
            headers["Authorization"] = "Bearer " + accessToken
        }
        
        self.xeeObjectsRequest("\(baseURL!)vehicles/\(vehicleId)/trips", headers:headers, objectType: XeeTrip.self) { (error, trips) in
            if let completionHandler = completionHandler {
                completionHandler(error, trips)
            }
        }
    }
    
    public func getTrip(WithTripID tripID:String, completionHandler: ((_ error: Error?, _ trip: XeeTrip?) -> Void)? ) {
        
        var headers: HTTPHeaders = [:]
        if let accessToken = XeeConnectManager.shared.token?.accessToken {
            headers["Authorization"] = "Bearer " + accessToken
        }
        
        self.xeeObjectRequest("\(baseURL!)trips/\(tripID)", headers:headers, objectType: XeeTrip.self) { (error, trip) in
            if let completionHandler = completionHandler {
                completionHandler(error, trip)
            }
        }
    }
    
    public func getSignals(WithTripID tripId:String, completionHandler: ((_ error: Error?, _ signals: [XeeSignal]?) -> Void)? ) {
        
        self.delegate.taskWillPerformHTTPRedirection = { session, task, response, request in
            var redirectedRequest = request
            
            if let originalRequest = task.originalRequest, let headers = originalRequest.allHTTPHeaderFields, let authorizationHeaderValue = headers["Authorization"] {
                let mutableRequest = request as! NSMutableURLRequest
                mutableRequest.setValue(authorizationHeaderValue, forHTTPHeaderField: "Authorization")
                redirectedRequest = mutableRequest as URLRequest
            }
            
            return redirectedRequest
        }
        
        var headers: HTTPHeaders = [:]
        if let accessToken = XeeConnectManager.shared.token?.accessToken {
            headers["Authorization"] = "Bearer " + accessToken
        }
        
        self.xeeObjectsRequest("\(baseURL!)trips/\(tripId)/signals", headers:headers, objectType: XeeSignal.self) { (error, signals) in
            if let completionHandler = completionHandler {
                completionHandler(error, signals)
            }
        }
    }
    
    public func getLocations(WithTripID tripId:String, completionHandler: ((_ error: Error?, _ locations: [XeeLocation]?) -> Void)? ) {
        
        self.delegate.taskWillPerformHTTPRedirection = { session, task, response, request in
            var redirectedRequest = request
            
            if let originalRequest = task.originalRequest, let headers = originalRequest.allHTTPHeaderFields, let authorizationHeaderValue = headers["Authorization"] {
                let mutableRequest = request as! NSMutableURLRequest
                mutableRequest.setValue(authorizationHeaderValue, forHTTPHeaderField: "Authorization")
                redirectedRequest = mutableRequest as URLRequest
            }
            
            return redirectedRequest
        }
        
        var headers: HTTPHeaders = [:]
        if let accessToken = XeeConnectManager.shared.token?.accessToken {
            headers["Authorization"] = "Bearer " + accessToken
        }
        
        self.xeeObjectsRequest("\(baseURL!)trips/\(tripId)/locations", headers:headers, objectType: XeeLocation.self) { (error, locations) in
            if let completionHandler = completionHandler {
                completionHandler(error, locations)
            }
        }
    }
    
    public func updateVehicle(WithVehicle vehicle:XeeVehicle, completionHandler: ((_ error: Error?, _ vehicle: XeeVehicle?) -> Void)? ) {
        
        let parameters: Parameters = vehicle.toJSON()
        
        var headers: HTTPHeaders = [:]
        if let accessToken = XeeConnectManager.shared.token?.accessToken {
            headers["Authorization"] = "Bearer " + accessToken
        }
        
        self.xeeObjectRequest("\(baseURL!)vehicles/\(vehicle.vehiculeID!)", method:.patch, parameters:parameters, encoding:JSONEncoding.default, headers:headers, objectType: XeeVehicle.self) { (error, vehicle) in
            if let completionHandler = completionHandler {
                completionHandler(error, vehicle)
            }
        }
    }
    
    public func getDevice(ForVehicleID vehicleId:String, completionHandler: ((_ error: Error?, _ device: XeeDevice?) -> Void)? ) {
        
        var headers: HTTPHeaders = [:]
        if let accessToken = XeeConnectManager.shared.token?.accessToken {
            headers["Authorization"] = "Bearer " + accessToken
        }
        
        self.xeeObjectRequest("\(baseURL!)vehicles/\(vehicleId)/device", headers:headers, objectType: XeeDevice.self) { (error, device) in
            if let completionHandler = completionHandler {
                completionHandler(error, device)
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
        
        self.xeeObjectsRequest("\(baseURL!)vehicles/\(vehicleId)/privacies", parameters:parameters, headers:headers, objectType: XeePrivacy.self) { (error, privacies) in
            if let completionHandler = completionHandler {
                completionHandler(error, privacies)
            }
        }
    }
    
    public func startPrivacy(ForVehicleID vehicleId:String, completionHandler: ((_ error: Error?, _ privacy: XeePrivacy?) -> Void)? ) {
        
        var headers: HTTPHeaders = [:]
        if let accessToken = XeeConnectManager.shared.token?.accessToken {
            headers["Authorization"] = "Bearer " + accessToken
        }
        
        self.xeeObjectRequest("\(baseURL!)vehicles/\(vehicleId)/privacies", method:.post, headers:headers, objectType: XeePrivacy.self) { (error, privacy) in
            if let completionHandler = completionHandler {
                completionHandler(error, privacy)
            }
        }
    }
    
    public func stopPrivacy(ForVPrivacyID privacyID:String, completionHandler: ((_ error: Error?, _ privacy: XeePrivacy?) -> Void)? ) {
        
        var headers: HTTPHeaders = [:]
        if let accessToken = XeeConnectManager.shared.token?.accessToken {
            headers["Authorization"] = "Bearer " + accessToken
        }
        
        self.xeeObjectRequest("\(baseURL!)privacies/\(privacyID)", method:.put, headers:headers, objectType: XeePrivacy.self) { (error, privacy) in
            if let completionHandler = completionHandler {
                completionHandler(error, privacy)
            }
        }
    }
    
    public func associateVehicle(WithXeeConnectId xeeConnectId:String, PinCode pin: String, completionHandler: ((_ error: Error?, _ vehicle: XeeVehicle?) -> Void)? ) {
        
        var headers: HTTPHeaders = [:]
        if let accessToken = XeeConnectManager.shared.token?.accessToken {
            headers["Authorization"] = "Bearer " + accessToken
        }
        
        var parameters: Parameters = [:]
        parameters["deviceId"] = xeeConnectId
        parameters["devicePin"] = pin
        
        self.xeeObjectRequest("\(baseURL!)users/me/vehicles", method:.post, parameters:parameters, encoding:JSONEncoding.default, headers:headers, objectType: XeeVehicle.self) { (error, vehicle) in
            if let completionHandler = completionHandler {
                completionHandler(error, vehicle)
            }
        }
    }

}
