//
//  XeeVehicle.swift
//  XeeSDK
//
//  Created by Jean-Baptiste Dujardin on 04/10/2017.
//

import ObjectMapper

open class XeeVehicle: XeeObject {

    public var vehicleID: String?
    public var name: String?
    public var brand: String?
    public var model: String?
    public var kType: String?
    public var licensePlate: String?
    public var createdAt: Date?
    public var updatedAt: Date?
    public var energy: String?
    public var device: XeeDevice?
    public var loan: XeeLoan?
    public var tags: [XeeTag]?
    public var firstEntryIntoService: Date?
    
    public override init() {
        super.init()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        vehicleID <- map["id"]
        name <- map["name"]
        brand <- map["brand"]
        model <- map["model"]
        kType <- map["kType"]
        licensePlate <- map["licensePlate"]
        createdAt <- (map["createdAt"], dateTransform)
        updatedAt <- (map["updatedAt"], dateTransform)
        energy <- map["energy"]
        device <- map["device"]
        loan <- map["loan"]
        tags <- map["tags"]
        firstEntryIntoService <- map["firstEntryIntoService"]
    }
    
}
