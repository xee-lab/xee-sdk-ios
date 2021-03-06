//
//  XeeUser.swift
//  XeeSDK
//
//  Created by Jean-Baptiste Dujardin on 04/10/2017.
//

import ObjectMapper

open class XeeUser: XeeObject {
    
    public var userID: String?
    public var gender: String?
    public var firstName: String?
    public var lastName: String?
    public var email: String?
    public var createdAt: Date?
    public var updatedAt: Date?
    
    public override init() {
        super.init()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    open override func mapping(map: Map) {
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
