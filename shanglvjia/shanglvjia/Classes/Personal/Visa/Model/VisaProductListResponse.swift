//
//  VisaProductListResponse.swift
//  shanglvjia
//
//  Created by manman on 2018/7/16.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON

class VisaProductListResponse: NSObject,ALSwiftyJSONAble {
    
    
    var count:NSInteger = 0
    var responses:[BaseVisaProductListVo] = Array()
    
    override init() {
        
    }
    
    required init?(jsonData: JSON) {
        self.count = jsonData["count"].intValue
        self.responses = jsonData["responses"].arrayValue.map{BaseVisaProductListVo.init(jsonData: $0)!}
    }
    
    
    
    
    class BaseVisaProductListVo:NSObject,ALSwiftyJSONAble {
        var id:String = ""
        var saleRate:Float = 0
        var visaName:String = ""
        var pic:String = ""
        override init() {
            
        }
        
        required init?(jsonData: JSON) {
            id = jsonData["id"].stringValue
            saleRate = jsonData["saleRate"].floatValue
            visaName = jsonData["visaName"].stringValue
            pic = jsonData["pic"].stringValue
        }
    }

}
