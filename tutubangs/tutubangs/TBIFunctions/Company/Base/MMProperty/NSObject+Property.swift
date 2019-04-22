//
//  NSObject+Property.swift
//  tbiVehicleClient
//
//  Created by manman on 2017/11/9.
//  Copyright © 2017年 com. All rights reserved.
//

import Foundation

extension NSObject
{
    
    
    
    /// 获取类的属性列表
    ///
    /// - Returns: 返回类的属性列表
    func properties() -> Array<MMProperty> {
        //class_copyPropertyList VS class_copyIvarList diffrent
        
        var propertiesArray:[MMProperty] = Array()
        var outCount:UInt32 = 0;
        let propertiesList = class_copyPropertyList(self.classForCoder, &outCount)
       for i in 0..<Int(outCount)
       {
        let property = propertiesList?[i]
        
        // add by manman
        // 如何查看 结构内容
        /*
        let propertyCopy = withUnsafePointer(to: &property, { (ptr:UnsafePointer<OpaquePointer>) -> objc_property_t in
          
            
        })
 
         */
       
        
        let mm_property:MMProperty = MMProperty.propertyWithProperty(property: property!)
        
        print(mm_property.name,mm_property.type?.typeClass)
        //let cName = property_getName(property)
        
        //let name = String.init(utf8String: cName!)
        propertiesArray.append(mm_property)
        }
        return propertiesArray
    }
    
}

