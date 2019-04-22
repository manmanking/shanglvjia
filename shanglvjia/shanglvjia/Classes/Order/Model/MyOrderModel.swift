//
//  MyOrderModel.swift
//  shanglvjia
//
//  Created by tbi on 2018/5/9.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON

class MyOrderModel: NSObject,ALSwiftyJSONAble {

    /// 起飞城市名 //test
    var takeOffCity:String!
    
    
    //mvvm
    var total :String = ""
    var orderInfos:[orderInfo] = Array()
    
    class orderInfo : NSObject ,ALSwiftyJSONAble {
        ///
        var amount:String = ""
        //预订人 姓名
        var bookerName:String = ""
        //预订时间
        var createTime:String = ""
        //预订时间
        var orderDetail:String = ""
        //预订号
        var orderNo:String = ""
        //预订号
        var orderId:String = ""
        //乘客姓名
        var orderPsgNames:String = ""
        //订单状态
        var orderState:String = ""
        //订单
        var orderTitle:String = ""
        //订单类型
        var orderType:String = ""
        
        
        override init() {
            
        }
        
        required   init(jsonData: JSON) {
            self.amount = jsonData["amount"].stringValue
            self.bookerName = jsonData["bookerName"].stringValue
            self.createTime = jsonData["createTime"].stringValue
            self.orderDetail = jsonData["orderDetail"].stringValue
            self.orderNo = jsonData["orderNo"].stringValue
            self.orderPsgNames = jsonData["orderPsgNames"].stringValue
            self.orderState = jsonData["orderState"].stringValue
            self.orderId = jsonData["orderId"].stringValue
            self.orderType = jsonData["orderType"].stringValue
            self.orderTitle = jsonData["orderTitle"].stringValue

        }
        
        
    }
    override init() {
        
    }
    required init?(jsonData: JSON) {
        
        self.total = jsonData["total"].stringValue
        self.orderInfos = jsonData["orderInfos"].arrayValue.map{ orderInfo(jsonData: $0) }

    }
    
}
