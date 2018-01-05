//
//  XeeSignal.swift
//  XeeSDK
//
//  Created by Jean-Baptiste Dujardin on 10/10/2017.
//

import ObjectMapper

open class XeeSignal: XeeObject {
    
    public var name: String?
    public var value: Double?
    public var date: Date?
    
    public override init() {
        super.init()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        name <- map["name"]
        value <- map["value"]
        date <- (map["date"], dateTransform)
    }
    
}
