//
//  XeeDevice.swift
//  XeeSDK
//
//  Created by Jean-Baptiste Dujardin on 04/10/2017.
//

import ObjectMapper

open class XeeDevice: XeeObject {
    
    public var deviceID: String?
    public var brand: String?
    public var vehicleID: String?
    
    public override init() {
        super.init()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        deviceID <- map["id"]
        brand <- map["brand"]
        vehicleID <- map["vehicleId"]
    }
    
}
