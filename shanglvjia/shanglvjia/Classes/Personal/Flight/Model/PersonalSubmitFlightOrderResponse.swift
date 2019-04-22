//
//  PersonalSubmitOrderResponse.swift
//  shanglvjia
//
//  Created by manman on 2018/8/16.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON


class PersonalSubmitFlightOrderResponse: NSObject ,ALSwiftyJSONAble{
    
    ///  1 二次确认 2 去支付
    var payStatus:String = ""
    var status:String = ""
    var orderIds:[String] = Array()
    override init() {
        
    }
    
    required init?(jsonData: JSON) {
        payStatus = jsonData["payStatus"].stringValue
        orderIds = jsonData["orderIds"].arrayValue.map{$0.stringValue}
        status = jsonData["status"].stringValue
    }
    
    
    
}
