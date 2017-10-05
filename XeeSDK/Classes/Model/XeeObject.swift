//
//  XeeObject.swift
//  XeeSDK
//
//  Created by Jean-Baptiste Dujardin on 04/10/2017.
//

import ObjectMapper

public class XeeObject: Mappable {
    
    public var error: String?
    public var errorMessage: String?
    
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
    
    public func mapping(map: Map) {
        error <- map["error"]
        errorMessage <- map["error_description"]
    }

}
