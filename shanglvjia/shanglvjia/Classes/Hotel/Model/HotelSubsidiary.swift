//
//  HotelSubsidiary.swift
//  shop
//
//  Created by manman on 2017/5/15.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import Moya_SwiftyJSONMapper
import SwiftyJSON

class HotelSubsidiary:NSObject,ALSwiftyJSONAble,DictionaryAble{
    
    var branchName:String = ""
    var lat:String = ""
    var lng:String = ""
    
    
    
    required init?(jsonData result: JSON) {
        
        self.branchName =  result["branchName"].stringValue
        self.lat = result["lat"].stringValue
        self.lng = result["lng"].stringValue
        
        
    }
    
    override init() {
        
    }
    
    
    
    
}

