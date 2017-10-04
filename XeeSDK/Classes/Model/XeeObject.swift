//
//  XeeObject.swift
//  XeeSDK
//
//  Created by Jean-Baptiste Dujardin on 04/10/2017.
//

import Foundation
import ObjectMapper

public class XeeObject: Mappable {
    
    var error: String?
    var errorMessage: String?
    
    required public init?(map: Map) {}
    
    public func mapping(map: Map) {
        error <- map["error"]
        errorMessage <- map["error_description"]
    }

}
