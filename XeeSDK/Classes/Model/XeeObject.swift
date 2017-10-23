//
//  XeeObject.swift
//  XeeSDK
//
//  Created by Jean-Baptiste Dujardin on 04/10/2017.
//

import ObjectMapper

open class XeeObject: Mappable {
    
    public var error: String?
    public var errorMessage: String?
    public var type: String?
    public var message: String?
    public var tip: String?
    
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
    
    open func mapping(map: Map) {
        error <- map["error"]
        errorMessage <- map["error_description"]
        type <- map["type"]
        message <- map["message"]
        tip <- map["tip"]
    }

}
