//
//  XeeObject.swift
//  XeeSDK
//
//  Created by Jean-Baptiste Dujardin on 04/10/2017.
//

import ObjectMapper

open class XeeObject: NSObject, Mappable {
    
    public override init() {
        super.init()
    }
    
    required public init?(map: Map) {}
    
    public let dateTransform = TransformOf<Date, String>(fromJSON: { (value: String?) -> Date? in
        if let value = value {
            return value.dateFromISO8601
        }else {
            return nil
        }
    }, toJSON: { (value: Date?) -> String? in
        if let value = value {
            return value.iso8601
        }else {
            return nil
        }
    })
    
    open func mapping(map: Map) {}

}
