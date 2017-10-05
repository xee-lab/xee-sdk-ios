//
//  XeeVehicle.swift
//  XeeSDK
//
//  Created by Jean-Baptiste Dujardin on 04/10/2017.
//

import ObjectMapper

public class XeeVehicle: XeeObject {

    public var vehiculeID: String?
    public var name: String?
    public var brand: String?
    public var model: String?
    public var kType: String?
    public var licensePlate: String?
    public var createdAt: Date?
    public var updatedAt: Date?
    public var device: XeeDevice?
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        vehiculeID <- map["id"]
        name <- map["name"]
        brand <- map["brand"]
        model <- map["model"]
        kType <- map["kType"]
        licensePlate <- map["licensePlate"]
        createdAt <- (map["createdAt"], dateTransform)
        updatedAt <- (map["updatedAt"], dateTransform)
        device <- map["device"]
    }
    
}
