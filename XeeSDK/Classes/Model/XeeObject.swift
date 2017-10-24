//
//  XeeObject.swift
//  XeeSDK
//
//  Created by Jean-Baptiste Dujardin on 04/10/2017.
//

import ObjectMapper

open class XeeObject: Mappable {
    
    required public init?(map: Map) {}
    
    let dateTransform = TransformOf<Date, String>(fromJSON: { (value: String?) -> Date? in
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
