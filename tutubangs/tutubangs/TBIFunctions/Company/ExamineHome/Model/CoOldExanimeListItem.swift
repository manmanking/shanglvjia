//
//  CoOldExanimeListItem.swift
//  shop
//
//  Created by akrio on 2017/5/27.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import SwiftDate
import Moya_SwiftyJSONMapper
import SwiftyJSON

/// 企业老版审批列表单项实体
struct CoOldExanimeListItem:ALSwiftyJSONAble {
    /// 唯一标示订单号
    let id:String
    /// 出差人姓名
    let pagNames:[String]
    /// 预订人姓名
    let bookerName:String
    /// 订单状态
    let orderState:CoOrderState
    /// 创建时间
    let createTime:DateInRegion
    /// 存在机票订单
    let hasFlight:Bool
    /// 存在酒店订单
    let hasHotel:Bool
    /// 存在列车订单
    let hasTrain:Bool
    /// 存在专车订单
    let hasCar:Bool
    init(jsonData:JSON){
        id = jsonData["orderNo"].stringValue
        pagNames = jsonData["orderPsgNames"].arrayValue.map{$0.stringValue}
        bookerName = jsonData["bookerName"].stringValue
        createTime = jsonData["createTime"].dateFormat(.unix)
        orderState = CoOrderState(rawValue: jsonData["orderState"].stringValue) ?? .unknow
        hasFlight = jsonData["flightOrders"].arrayValue.count > 0
        hasHotel = jsonData["hotelOrders"].arrayValue.count > 0
        hasTrain = jsonData["trainOrderItems"].arrayValue.count > 0
        hasCar = jsonData["carOrderItems"].arrayValue.count > 0
    }
}
