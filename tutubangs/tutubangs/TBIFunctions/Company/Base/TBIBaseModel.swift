//
//  TBIBaseModel.swift
//  shop
//
//  Created by manman on 2018/3/5.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON
import MJExtension

class TBIBaseModel: NSObject,NSCoding,ALSwiftyJSONAble {
    
    
    override init() {
        super.init()
    }

    
    

    func encode(with aCoder: NSCoder) {

        var outCount:CUnsignedInt = 0
        let vars:UnsafeMutablePointer = class_copyIvarList(self.classForCoder, &outCount)

        for i in 0...outCount-1
        {
            let tmpVar = vars[Int(i)]

            let name:UnsafePointer = ivar_getName(tmpVar)

            let key:String = String.init(utf8String: name)!

            let value = self.value(forKey: key)
            aCoder.encode(value, forKey: key)

        }

    }

    required init?(coder aDecoder: NSCoder) {

        super.init()
        var outCount:CUnsignedInt = 0

        let vars:UnsafeMutablePointer = class_copyIvarList(self.classForCoder, &outCount)
        for i in 0...outCount-1
        {
            let tmpVar:Ivar = vars[Int(i)]!

            let name:UnsafePointer = ivar_getName(tmpVar)

            let key = String.init(utf8String: name)

            let value = aDecoder.decodeObject(forKey: key!)

            self.setValue(value, forKey: key!)


        }


    }

//
//        required init?(jsonData: JSON) {
//            super.init()
//
//            let ivarList:[MMProperty] = self.properties()
//            for element in ivarList {
//                printDebugLog(message: element.mj_keyValues())
//            }
////            for (index,element) in ivarList.enumerated()
////            {
////                if element.name ==
////
////
////
////                self.setValue(jsonData[element].stringValue, forKey: element)
////            }
//
//
//            for i in 0...ivarList.count
//            {
//                let tmpVar:Ivar = vars[Int(i)]!
//
//                let name:UnsafePointer = ivar_getName(tmpVar)
//
//                let key:String = String.init(utf8String: name) ?? ""
//
//                // 现在将类型暂时 转化为string 类型  需要优化
//
//                 class_getProperty(AnyClass, name)
//                var keyValue:Any?
//                for element in properties()
//                {
//                    if element.name == key
//                    {
//                        if NSString.isKind(of: (element.type?.typeClass)!)
//                        {
//                            keyValue = jsonData[key].stringValue
//
//                        }
//
//
//                    }
//
//                }
//
//
//
//
//                // end of line
//
////
////                self.setValue(jsonData[key].stringValue, forKey: key)
////
////                print(key,jsonData[key].stringValue)
//
//            }
//        }
//


    
    required init?(jsonData: JSON) {
        super.init()

        let ivarList = self.propertyOfSelf()
        for element in ivarList
        {

            self.setValue(jsonData[element].stringValue, forKey: element)
        }
    }


    
    private func propertyOfSelf() -> Array<String> {

        var count:CUnsignedInt = 0
        
        let ivarList:UnsafeMutablePointer = class_copyIvarList(self.classForCoder, &count)
        var properNames:[String] = Array()
        
        for index in 0...count-1
        {
            let tmpVar:Ivar = ivarList[Int(index)]!
            let name:String = String.init(utf8String:ivar_getName(tmpVar))!
            
            properNames.append(name)
        }
        
        return properNames

    }
}

