//
//  CoOldOrderListItem.swift
//  shop
//
//  Created by akrio on 2017/5/15.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import Moya_SwiftyJSONMapper
import SwiftyJSON
import SwiftDate

/// 企业老版订单列表
struct CoOldOrderListItem : ALSwiftyJSONAble{
    /// 订单号
    let orderNo:String
    /// 订单状态
    let orderState:CoOrderState
    /// 是否存在酒店订单
    let hasHotel:Bool
    /// 是否存在机票订单
    let hasFlight:Bool
    /// 出差人
    let orderPsgNames:[String]
    /// 预订人
    let bookerName:String
    /// 创建时间
    let createTime:DateInRegion
    /// 存在列车订单
    let hasTrain:Bool
    /// 存在专车订单
    let hasCar:Bool
    init (jsonData: JSON) {
        self.orderNo = jsonData["orderNo"].stringValue
        self.orderState = CoOrderState(rawValue: jsonData["orderState"].stringValue) ?? .unknow
        self.hasHotel = !jsonData["hotelOrders"].arrayValue.isEmpty
        self.hasFlight = !jsonData["flightOrders"].arrayValue.isEmpty
        self.orderPsgNames = jsonData["orderPsgNames"].arrayValue.map{ $0.stringValue }
        self.bookerName = jsonData["bookerName"].stringValue
        createTime = jsonData["createTime"].dateFormat(.unix)
        hasTrain = jsonData["trainOrderItems"].arrayValue.count > 0
        hasCar = jsonData["carOrderItems"].arrayValue.count > 0
    }
}
