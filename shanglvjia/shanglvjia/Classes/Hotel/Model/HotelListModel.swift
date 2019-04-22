//
//  HotelListModel.swift
//  shop
//
//  Created by manman on 2017/8/30.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON


class HotelListModel: NSObject,ALSwiftyJSONAble,NSCoding {
    /// 酒店id
    var id:String?
    /// 酒店名称
    var name:String?
    /// 酒店星级
    var starRate:Int?
    /// 艺龙星级
    var category:Int?
    /// 酒店地址
    var address:String?
    /// 酒店电话
    var phone:String?
    /// 酒店设施
    var facilities:String?
    /// 酒店封面
    var imgUrl:String?
    /// 酒店类型
    var hotelType:String?
    /// 纬度
    var latitude:Double?
    /// 经度
    var longitude:Double?
    //(number): 差标 ,
    var accordTravel:Float?
    /// 酒店最低价格
    var lowRate:Int?
   
    
    
    override init() {
        super.init()
        
    }
    
    /*
     // 取得所有成员变量名
     NSArray *properNames = [[self class] propertyOfSelf];
     
     for (NSString *propertyName in properNames) {
     // 创建指向get方法
     SEL getSel = NSSelectorFromString(propertyName);
     // 对每一个属性实现归档
     [enCoder encodeObject:[self performSelector:getSel] forKey:propertyName];
     }
     
     
     */
    
    
    func encode(with aCoder: NSCoder) {
        
        let propertiesNames:[String] = self.propertyOfSelf()
        
        for element in propertiesNames {
            
            let getSel:Selector = NSSelectorFromString(element)
            aCoder.encode(self.perform(getSel), forKey: element)
        }
        
        
        
        
        
        
    }
    
    /*
     
     if (self = [super init]) {
     unsigned int count = 0;
     //获取类中所有成员变量名
     Ivar *ivar = class_copyIvarList([MyModel class], &count);
     for (int i = 0; i<count; i++) {
     Ivar iva = ivar[i];
     const char *name = ivar_getName(iva);
     NSString *strName = [NSString stringWithUTF8String:name];
     //进行解档取值
     id value = [decoder decodeObjectForKey:strName];
     //利用KVC对属性赋值
     [self setValue:value forKey:strName];
     }
     free(ivar);
     }
     return self;
     
     */
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
    
        let ivarList = self.propertyOfSelf()
        for element in ivarList
        {
            
            let value = aDecoder.decodeObject(forKey: element)
            self.setValue(value, forKey: element)
        }
        
        
        
        
        
        
        
        
        
        
    }
    
// MARK:-----------  Incomplete the task
    required init (jsonData jItem: JSON) {
        super.init()
        
        // 1、 获得属性名称 ✅
        // 2、 获取属性类型 ⛔️
//        let varList = self.propertyOfSelf()
//        for element in varList {
//           jItem[element]
//            
//            
//            
//            
//            
//            
//        }
        
        
        
        
        
        self.id = jItem["hotelId"].stringValue
        self.name = jItem["hotelName"].stringValue
        self.starRate = jItem["starRate"].intValue
        self.address = jItem["address"].stringValue
        self.phone = jItem["phone"].stringValue
        self.category = jItem["category"].intValue
        self.facilities = jItem["facilities"].stringValue
        self.imgUrl = jItem["imgUrl"].stringValue
        self.hotelType = jItem["hotelType"].stringValue
        self.latitude = jItem["lat"].doubleValue
        self.accordTravel = jItem["accordTravel"].floatValue
        self.longitude = jItem["lon"].doubleValue
        self.lowRate = jItem["lowRate"].intValue
    }
    
    
    /*
     // 返回self的所有对象名称
     + (NSArray *)propertyOfSelf{
     unsigned int count;
     
     // 1. 获得类中的所有成员变量
     Ivar *ivarList = class_copyIvarList(self, &count);
     
     NSMutableArray *properNames =[NSMutableArray array];
     for (int i = 0; i < count; i++) {
     Ivar ivar = ivarList[i];
     
     // 2.获得成员属性名
     NSString *name = [NSString stringWithUTF8String:ivar_getName(ivar)];
     
     // 3.除去下划线，从第一个角标开始截取
     NSString *key = [name substringFromIndex:1];
     
     [properNames addObject:key];
     }
     
     return [properNames copy];
     }
     
     
     */
    
    
    private func propertyOfSelf() -> Array<String> {
        
        var count:CUnsignedInt = 0
        
        let ivarList:UnsafeMutablePointer = class_copyIvarList(self.classForCoder, &count)
        var properNames:[String] = Array()
        
        for index in 0...count
        {
            let tmpVar:Ivar = ivarList[Int(index)]!
            let name:String = String.init(utf8String:ivar_getName(tmpVar))!
            
            properNames.append(name)
        }
        
        return properNames
        
    }
    
    
    
    
    
}
