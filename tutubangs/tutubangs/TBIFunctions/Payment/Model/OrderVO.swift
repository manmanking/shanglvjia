//
//  OrderVO.swift
//  shop
//
//  Created by manman on 2017/9/21.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

import Moya_SwiftyJSONMapper
import SwiftyJSON
import SwiftDate

class OrderVO: NSObject,ALSwiftyJSONAble {
    //: 订单号 ,
    var orderNo:String?
    //): 订单状态 ,
    var orderStatus:String?
    //支付剩余时间 ,
    var timeRemaining:NSInteger = 0
    //): 支付截止时间 ,
    var paymentDeadline:String?
    //): 订单总价
    var orderTotalAmount:NSNumber = 0
    
    required init?(jsonData jItem: JSON) {
        
        self.orderNo = jItem["orderNo"].stringValue
        self.orderStatus = jItem["orderStatus"].stringValue
        self.timeRemaining = jItem["timeRemaining"].intValue
        self.paymentDeadline = jItem["paymentDeadline"].stringValue
        self.orderTotalAmount = jItem["orderTotalAmount"].numberValue
        
    }
    
}
