//
//  XeeDriver.swift
//  XeeSDK
//
//  Created by Jean-Baptiste Dujardin on 23/04/2018.
//

import ObjectMapper

open class XeeDriver: XeeObject {
    
    public var firstName: String?
    public var gender: String?
    public var driverID: String?
    public var lastName: String?
    public var loan: XeeLoan?
    public var tags: [XeeTag]?
    public var nextChecking: Date?
    
    public override init() {
        super.init()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        gender <- map["gender"]
        driverID <- map["id"]
        loan <- map["loan"]
        tags <- map["tags"]
        nextChecking <- (map["nextChecking"], dateTransform)
    }
    
}
