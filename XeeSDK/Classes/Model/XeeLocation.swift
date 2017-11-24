//
//  XeeLocation.swift
//  XeeSDK
//
//  Created by Jean-Baptiste Dujardin on 10/10/2017.
//

import ObjectMapper

public class XeeLocation: XeeObject {
    
    public var latitude: Double?
    public var longitude: Double?
    public var date: Date?
    public var heading: Double?
    public var altitude: Double?
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        date <- (map["date"], dateTransform)
        heading <- map["heading"]
        altitude <- map["altitude"]
    }
    
}