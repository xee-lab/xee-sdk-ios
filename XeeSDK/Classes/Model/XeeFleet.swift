//
//  XeeFleet.swift
//  XeeSDK
//
//  Created by Jean-Baptiste Dujardin on 23/04/2018.
//

import ObjectMapper

open class XeeFleet: XeeObject {
    
    public var active: Bool?
    public var company: String?
    public var fleetID: String?
    public var joinedAt: Date?
    public var name: String?
    public var role: String?
    
    public override init() {
        super.init()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        active <- map["active"]
        company <- map["company"]
        fleetID <- map["id"]
        joinedAt <- (map["joinedAt"], dateTransform)
        name <- map["name"]
        role <- map["role"]
    }
    
}
