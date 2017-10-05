//
//  XeeDevice.swift
//  XeeSDK
//
//  Created by Jean-Baptiste Dujardin on 04/10/2017.
//

import ObjectMapper

public class XeeDevice: XeeObject {
    
    public var deviceID: String?
    public var brand: String?
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        deviceID <- map["id"]
        brand <- map["brand"]
    }
    
}
