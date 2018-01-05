//
//  XeeStatus.swift
//  XeeSDK
//
//  Created by Jean-Baptiste Dujardin on 10/10/2017.
//

import ObjectMapper

open class XeeStatus: XeeObject {
    
    public var location: XeeLocation?
    public var vehicleID: String?
    public var createdAt: Date?
    public var updatedAt: Date?
    public var accelerometer: XeeAccelerometer?
    public var signals: [XeeSignal]?
    
    public override init() {
        super.init()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        location <- map["location"]
        vehicleID <- map["vehicleId"]
        createdAt <- (map["createdAt"], dateTransform)
        updatedAt <- (map["updatedAt"], dateTransform)
        accelerometer <- map["accelerometer"]
        signals <- map["signals"]
    }
    
}
