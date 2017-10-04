//
//  XeeAccessToken.swift
//  XeeSDK
//
//  Created by Jean-Baptiste Dujardin on 03/10/2017.
//

import ObjectMapper

public class XeeToken: XeeObject {
    
    var tokenType: String?
    var refreshToken: String?
    var scope: String?
    var accessToken: String?
    var expiresIn: Int?

    required public init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        tokenType <- map["token_type"]
        refreshToken <- map["refresh_token"]
        scope <- map["scope"]
        accessToken <- map["access_token"]
        expiresIn <- map["expires_in"]
    }
    
}
