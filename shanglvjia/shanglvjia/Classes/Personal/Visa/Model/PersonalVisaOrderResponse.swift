//
//  PersonalVisaOrderResponse.swift
//  shanglvjia
//
//  Created by manman on 2018/8/16.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON

class PersonalVisaOrderResponse: NSObject,ALSwiftyJSONAble {

    ///  1 二次确认 2 去支付
    var orderStatus:String = ""
    var orderNo:String = ""
    var orderId:String = ""
    override init() {
        
    }
    
    required init?(jsonData: JSON) {
        orderId = jsonData["orderId"].stringValue
        orderNo = jsonData["orderNo"].stringValue
        orderStatus = jsonData["orderStatus"].stringValue
    }
}
