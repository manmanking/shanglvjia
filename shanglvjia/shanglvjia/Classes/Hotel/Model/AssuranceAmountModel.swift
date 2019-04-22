//
//  AssuranceAmountModel.swift
//  shop
//
//  Created by manman on 2017/6/5.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class AssuranceAmountModel: NSObject,NSCoding {
    var hotelId:String = ""
    var ArrivalDate:String = ""
    var DepartureDate:String = ""
    var ratePlanId:String = ""
    var roomNum:String = ""
    var roomTypeId:String = ""
    
    
    override init() {
        
    }
    
    
    
    func encode(with aCoder: NSCoder) {
        
        var outCount:CUnsignedInt = 0
        let vars:UnsafeMutablePointer = class_copyIvarList(self.classForCoder, &outCount)
        
        for i in 0...outCount
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
            for i in 0...outCount
            {
                let tmpVar:Ivar = vars[Int(i)]!
                
                let name:UnsafePointer = ivar_getName(tmpVar)
                
                let key = String.init(utf8String: name)
                
                let value = aDecoder.decodeObject(forKey: key!)
                
                self.setValue(value, forKey: key!)
                
                
            }
        
        
    }
    
    
    
    
    
    
    
}
