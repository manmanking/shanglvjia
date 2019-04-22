//
//  MMProperty.swift
//  tbiVehicleClient
//
//  Created by manman on 2017/11/10.
//  Copyright © 2017年 com. All rights reserved.
//

import UIKit

class MMProperty: NSObject {

    var name:String?
    //如何变为只读
//    var name:String{
//        get{
//            return self.name
//        }
//
//    }
    var type:MMProperptyType?
    //如何变为只读
//    var type:MMProperptyType{
//        get{
//            return self.type
//        }
//    }
//
//
    class func propertyWithProperty(property:objc_property_t)->MMProperty {
        
        return MMProperty().initWithProperty(property:property)
    }
    
    
    private func initWithProperty(property:objc_property_t) -> MMProperty {
        self.name = String.init(utf8String:property_getName(property))
        self.type = MMProperptyType.propertyTypeWithAttributeString(attribute:String.init(utf8String: property_getAttributes(property))!)
        return self
        
        
        
    }
    
    
}
