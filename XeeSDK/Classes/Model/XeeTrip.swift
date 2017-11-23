//
//  XeeTrip.swift
//  XeeSDK
//
//  Created by Jean-Baptiste Dujardin on 10/10/2017.
//

import ObjectMapper

public class XeeTrip: XeeObject {
    
    public var tripID: String?
    public var startLocation: XeeLocation?
    public var endLocation: XeeLocation?
    public var createdAt: Date?
    public var updatedAt: Date?
    public var vehicleID: String?
    public var distance: Double?
    public var duration: Double?
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        tripID <- map["id"]
        startLocation <- map["startLocation"]
        endLocation <- map["endLocation"]
        createdAt <- (map["createdAt"], dateTransform)
        updatedAt <- (map["updateAt"], dateTransform)
        vehicleID <- map["vehicleId"]
        distance <- map["stats.distance"]
        duration <- map["stats.duration"]
    }
    
}
