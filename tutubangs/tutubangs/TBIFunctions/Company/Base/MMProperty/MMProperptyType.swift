//
//  MMProperptyType.swift
//  tbiVehicleClient
//
//  Created by manman on 2017/11/10.
//  Copyright © 2017年 com. All rights reserved.
//

import UIKit
import MJExtension

class MMProperptyType: NSObject {

    var idType:Bool?
    /** 是否为id类型 */
//    var idType:Bool {
//        get{
//            return self.idType
//        }
//    }
    var numberType:Bool?
    /** 是否为基本数字类型：int、float等 */
//    var numberType:Bool{
//        get{
//            return self.numberType
//        }
//    }
    var boolType:Bool?
    /** 是否为BOOL类型 */
//    var boolType:Bool{
//        get{
//            return self.boolType
//        }
//    }
    var typeClass:AnyClass?
    /** 对象类型（如果是基本数据类型，此值为nil） */
//    var typeClass:AnyClass{
//        get{
//            return self.typeClass
//        }
//    }
    
    
    class func propertyTypeWithAttributeString(attribute:String) -> MMProperptyType {
        
        return MMProperptyType().initWithTypeString(type: attribute)
        
    }
    
    
    private func initWithTypeString(type:String) -> MMProperptyType {
        
        
        let local:Int = 1
        let len:Int = (type as NSString).range(of: ",").location - local
        let typeCode:String = (type as NSString).substring(with: NSRange.init(location: local, length: len))
        getTypeWithCode(code: typeCode)
        return self
//        NSUInteger len = [string rangeOfString:@","].location - loc;
//        NSString *typeResult = [string substringWithRange:NSMakeRange(loc, len)];
        
        
    }
    
    private func getTypeWithCode(code:String) {
        
        if code == MJPropertyTypeId {
            self.idType = true
        }else if code.count > 3 && code.hasPrefix("@\"")
        {
            
            //let codeCopy:NSString =
            let codeCopy :NSString = (code as NSString).substring(with: NSRange.init(location: 2, length: (code as NSString).length - 3 )) as NSString
            
            self.typeClass = NSClassFromString(codeCopy as String)
            self.numberType = (self.typeClass == NSNumber.self || (self.typeClass?.isSubclass(of: NSNumber.classForCoder()))!)
            
        }
        let lowerCode:String = code.lowercased()
        let numberTypes:[String] = [MJPropertyTypeInt, MJPropertyTypeShort, MJPropertyTypeBOOL1, MJPropertyTypeBOOL2, MJPropertyTypeFloat, MJPropertyTypeDouble, MJPropertyTypeLong, MJPropertyTypeChar]
        if numberTypes.contains(lowerCode) {
            self.numberType = true
            if lowerCode == MJPropertyTypeBOOL1 || lowerCode == MJPropertyTypeBOOL2
            {
                self.boolType = true
            }
        }
            
    }
//
//        if ([code isEqualToString:MJPropertyTypeId]) {
//            _idType = YES;
//        } else if (code.length > 3 && [code hasPrefix:@"@\""]) {
//            // 去掉@"和"，截取中间的类型名称
//            _code = [code substringWithRange:NSMakeRange(2, code.length - 3)];
//            _typeClass = NSClassFromString(_code);
//            _numberType = (_typeClass == [NSNumber class] || [_typeClass isSubclassOfClass:[NSNumber class]]);
//        }
//
//        // 是否为数字类型
//        NSString *lowerCode = _code.lowercaseString;
//        NSArray *numberTypes = @[MJPropertyTypeInt, MJPropertyTypeShort, MJPropertyTypeBOOL1, MJPropertyTypeBOOL2, MJPropertyTypeFloat, MJPropertyTypeDouble, MJPropertyTypeLong, MJPropertyTypeChar];
//        if ([numberTypes containsObject:lowerCode]) {
//            _numberType = YES;
//
//            if ([lowerCode isEqualToString:MJPropertyTypeBOOL1]
//                || [lowerCode isEqualToString:MJPropertyTypeBOOL2]) {
//                _boolType = YES;
//            }
//        }
//    }
    
}
