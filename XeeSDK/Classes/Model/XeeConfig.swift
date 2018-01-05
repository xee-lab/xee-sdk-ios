//
//  XeeConfig.swift
//  XeeSDK
//
//  Created by Jean-Baptiste Dujardin on 03/10/2017.
//

import UIKit

public enum XeeEnvironment: String {
    case XeeEnvironmentSTAGING = "https://staging.xee.com/v4/"
    case XeeEnvironmentCLOUD = "https://api.xee.com/v4/"
    case XeeEnvironmentSANDBOX = "https://sandbox.xee.com/v4/"
}

public class XeeConfig: NSObject {
    
    public var clientID: String?
    public var secretKey: String?
    public var scopes: [String]?
    public var redirectURI: String?
    public var userAgent: String?
    public var environment: XeeEnvironment?
    
    public override init() {
        super.init()
        self.environment = .XeeEnvironmentCLOUD
        self.userAgent = "SDK Xee iOS"
    }
    
    public convenience init(withClientID clientID: String?, SecretKet secretKey: String?, Scopes scopes: [String]?, RedirectURI redirectURI: String?, Environment environment: XeeEnvironment?) {
        self.init()
        if let clientID = clientID {
            self.clientID = clientID
        }
        if let secretKey = secretKey {
            self.secretKey = secretKey
        }
        if let scopes = scopes {
            self.scopes = scopes
        }
        if let redirectURI = redirectURI {
            self.redirectURI = redirectURI
        }
        if let environment = environment {
            self.environment = environment
        }
    }

}
