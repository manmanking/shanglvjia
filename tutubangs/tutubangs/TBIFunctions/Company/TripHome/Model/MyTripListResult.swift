//
//  MyTripListResponse.swift
//  shop
//
//  Created by zhanghao on 2017/7/12.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import SwiftyJSON
import Moya_SwiftyJSONMapper
import SwiftDate

struct MyTripListResponse : ALSwiftyJSONAble{
    let orderId:String// (string): 订单id ,
    let orderNo:String // (string): 订单号 ,
    let orderTitle1:String// (string): 标题1 ,
    let orderTitle2:String// (string): 标题2 ,
    let orderDescribe1:String // (string): 描述1 ,
    let orderDescribe2:String // (string): 描述2 ,
    let commodity:Int// (integer): 类型 ,
    let commodityName:String // (string): 类型名称 ,
    let totalAmount:String// (string): 价格 ,
    let orderStatus:Int// (integer): 订单状态 ,
    let tripDate:String // (string): 出行日期 ,
    let head:String // (string): 头部 ,
    let foot:String // (string): 脚部
    
    init(jsonData result:JSON){
        self.orderId = result["orderId"].stringValue
        self.orderNo = result["orderNo"].stringValue
        self.orderTitle1 = result["orderTitle1"].stringValue
        self.orderTitle2 = result["orderTitle2"].stringValue
        self.orderDescribe1 = result["orderDescribe1"].stringValue
        self.orderDescribe2 = result["orderDescribe2"].stringValue
        self.commodity = result["commodity"].intValue
        self.commodityName = result["commodityName"].stringValue
        self.totalAmount = result["totalAmount"].stringValue
        self.orderStatus = result["orderStatus"].intValue
        self.tripDate = result["tripDate"].stringValue
        self.head = result["head"].stringValue
        self.foot = result["foot"].stringValue
    }
}
