//
//  XeeUser.swift
//  XeeSDK
//
//  Created by Jean-Baptiste Dujardin on 04/10/2017.
//

import ObjectMapper
import AFDateHelper

public class XeeUser: XeeObject {
    
    var userID: String?
    var gender: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var createdAt: Date?
    var updatedAt: Date?
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        userID <- map["id"]
        gender <- map["gender"]
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        email <- map["email"]
        createdAt <- (map["createdAt"], dateTransform)
        updatedAt <- (map["updatedAt"], dateTransform)
    }
    
}
