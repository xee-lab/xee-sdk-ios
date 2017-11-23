//
//  XeeAccelerometer.swift
//  XeeSDK
//
//  Created by Jean-Baptiste Dujardin on 10/10/2017.
//

import ObjectMapper

public class XeeAccelerometer: XeeObject {
    
    public var x: Double?
    public var y: Double?
    public var z: Double?
    public var nda: Double?
    public var date: Date?
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        x <- map["x"]
        y <- map["y"]
        z <- map["z"]
        nda <- map["-"]
        date <- (map["date"], dateTransform)
    }
    
}

