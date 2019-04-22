//
//  OrderListItem.swift
//  shop
//
//  Created by akrio on 2017/5/12.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import Moya_SwiftyJSONMapper
import SwiftyJSON

struct OrderListItem : ALSwiftyJSONAble{
    /// 订单id
    let orderId:String
    /// 订单号
    let orderNo:String
    /// 标题
    let orderTitle:String
    /// 描述1
    let orderDescribe1:String
    /// 描述2
    let orderDescribe2:String
    /// 类型
    let commodity:Int
    /// 类型名称
    let commodityName:String
    /// 价格
    let totalAmount:String
    /// 订单状态
    let orderStatus:OrderStatus
    /// 下单时间
    let createTime:String
    init(jsonData: JSON) {
        self.orderId = jsonData["orderId"].stringValue
        self.orderNo = jsonData["orderNo"].stringValue
        self.orderTitle = jsonData["orderTitle"].stringValue
        self.orderDescribe1 = jsonData["orderDescribe1"].stringValue
        self.orderDescribe2 = jsonData["orderDescribe2"].stringValue
        self.commodity = jsonData["commodity"].intValue
        self.commodityName = jsonData["commodityName"].stringValue
        self.totalAmount = jsonData["totalAmount"].doubleValue.priceText()
        self.orderStatus = OrderStatus(rawValue: jsonData["orderStatus"].intValue) ?? .unknow
        self.createTime = jsonData["createTime"].stringValue
    }
}
