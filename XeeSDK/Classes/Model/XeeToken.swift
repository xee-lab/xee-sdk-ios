//
//  XeeAccessToken.swift
//  XeeSDK
//
//  Created by Jean-Baptiste Dujardin on 03/10/2017.
//

import ObjectMapper

open class XeeToken: XeeObject {
    
    public var tokenType: String?
    public var refreshToken: String?
    public var scope: String?
    public var accessToken: String?
    public var expiresIn: Int?
    
    public override init() {
        super.init()
    }

    required public init?(map: Map) {
        super.init(map: map)
    }
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        tokenType <- map["token_type"]
        refreshToken <- map["refresh_token"]
        scope <- map["scope"]
        accessToken <- map["access_token"]
        expiresIn <- map["expires_in"]
    }
    
}
