//
//  XeeLoan.swift
//  XeeSDK
//
//  Created by Jean-Baptiste Dujardin on 23/04/2018.
//

import ObjectMapper

open class XeeLoan: XeeObject {
    
    public var endedAt: Date?
    public var loanID: String?
    public var startedAt: Date?
    public var vehicle: XeeVehicle?
    
    public override init() {
        super.init()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        endedAt <- (map["endedAt"], dateTransform)
        loanID <- map["id"]
        startedAt <- (map["startedAt"], dateTransform)
        vehicle <- map["vehicle"]
    }
    
}
