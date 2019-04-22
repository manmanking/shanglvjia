//
//  NSobject+KeyValue2Object.swift
//  tbiVehicleClient
//
//  Created by manman on 2017/11/10.
//  Copyright © 2017年 com. All rights reserved.
//



import Foundation

extension NSObject
{
    
    
//    /// 暂时这样 以后优化
//    ///
//    /// - Parameter keyValues:
//    /// - Returns:
//    class func objectWithKeyValues(keyValues:AnyClass) -> AnyClass? {
//
//        guard keyValues != nil else {
//            return nil
//        }
//        return self.keyValues(keyValues:keyValues)
//        //JSONObject()
//
//    }
//
//   private func keyValues(keyValues:AnyClass) -> AnyClass? {
//
//
//    let propertiesArray:[MMProperty] = self.properties()
//
//    for element in propertiesArray {
//        let type:MMProperptyType = element.type!
//        let typeClass:AnyClass = type.typeClass!
//
//        if (type.boolType ?? false ) {
//            printDebugLog(message: "bool value")
//        }else if type.idType ?? false {
//            printDebugLog(message: "id value")
//        }else if type.numberType ?? false {
//            printDebugLog(message: "id value")
//        }else {
//            printDebugLog(message:typeClass)
//        }
//
//
//
//    }
//    return self as! AnyClass
//
////
////    NSArray *propertiesArray = [self.class properties];
////    for (MJProperty *property in propertiesArray) {
////        MJPropertyType *type = property.type;
////        Class typeClass = type.typeClass;
////
////        id value = [keyValues valueForKey:[self.class propertyKey:property.name]];
////        if (!value) continue;
////
////        if (!type.isFromFoundation && typeClass) {
////            value = [typeClass objectWithKeyValues:value];
////        }else if ([self.class respondsToSelector:@selector(objectClassInArray)]){
////            id objectClass;
////            objectClass = [self.class objectClassInArray][property.name];
////
////            // 如果是NSString类型
////            if ([objectClass isKindOfClass:[NSString class]]) {
////                objectClass = NSClassFromString(objectClass);
////            }
////
////            if (objectClass) {
////                // 返回一个装了模型的数组
////                value = [objectClass objectArrayWithKeyValuesArray:value];
////            }
////
////        }else if (type.isNumberType){
////            NSString *oldValue = value;
////            // 字符串->数字
////            if ([value isKindOfClass:[NSString class]]){
////                value = [[[NSNumberFormatter alloc] init] numberFromString:value];
////                if (type.isBoolType) {
////                    NSString *lower = [oldValue lowercaseString];
////                    if ([lower isEqualToString:@"yes"] || [lower isEqualToString:@"true"] ) {
////                        value = @YES;
////                    } else if ([lower isEqualToString:@"no"] || [lower isEqualToString:@"false"]) {
////                        value = @NO;
////                    }
////                }
////            }
////        }
////        else{
////            if (typeClass == [NSString class]) {
////                if ([value isKindOfClass:[NSNumber class]]) {
////                    if (type.isNumberType)
////                    // NSNumber -> NSString
////                    value = [value description];
////                }else if ([value isKindOfClass:[NSURL class]]){
////                    // NSURL -> NSString
////                    value = [value absoluteString];
////                }
////            }
////        }
////        [self setValue:value forKey:property.name];
////    }
////
//
//    }
//
//
//
//     func JSON2Object() {
//
//        var foundationObj:AnyClass?
//
//        if self.isKind(of: NSString.classForCoder()) {
//
//            foundationObj = JSONSerialization.data(withJSONObject: self, options:kNilOptions)
//
//        }else
//        {
//
//        }
//
//    }
//
//
//    - (id)JSONObject{
//    id foundationObj;
//    if ([self isKindOfClass:[NSString class]]) {
//    foundationObj = [NSJSONSerialization JSONObjectWithData:[(NSString *)self dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
//    }else if ([self isKindOfClass:[NSData class]]){
//    foundationObj = [NSJSONSerialization JSONObjectWithData:(NSData *)self options:kNilOptions error:nil];
//    }
//    return foundationObj?:self;
//    }

    
    
    
    
}
