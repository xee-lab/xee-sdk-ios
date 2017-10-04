//
//  XeeObject.swift
//  XeeSDK
//
//  Created by Jean-Baptiste Dujardin on 04/10/2017.
//

import ObjectMapper

public class XeeObject: Mappable {
    
    var error: String?
    var errorMessage: String?
    
    required public init?(map: Map) {}
    
    let dateTransform = TransformOf<Date, String>(fromJSON: { (value: String?) -> Date? in
        if let value = value {
            return Date(fromString: value, format: .custom("yyyy-MM-dd'T'HH:mm:ssZZZZZ"), locale:Locale(identifier: "en_US_POSIX"))
        }else {
            return nil
        }
    }, toJSON: { (value: Date?) -> String? in
        if let value = value {
            return value.toString(format: .custom("yyyy-MM-dd'T'HH:mm:ssZZZZZ"), locale:Locale(identifier: "en_US_POSIX"))
        }else {
            return nil
        }
    })
    
    public func mapping(map: Map) {
        error <- map["error"]
        errorMessage <- map["error_description"]
    }

}
