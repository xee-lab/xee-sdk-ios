//
//  XeeTag.swift
//  XeeSDK
//
//  Created by Jean-Baptiste Dujardin on 23/04/2018.
//

import ObjectMapper

open class XeeTag: XeeObject {
    
    public var color: String?
    public var icon: String?
    public var tagID: String?
    public var name: String?
    
    public override init() {
        super.init()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        color <- map["color"]
        icon <- map["icon"]
        tagID <- map["id"]
        name <- map["name"]
    }
    
}
