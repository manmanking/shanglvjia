//
//  CabinListItem.swift
//  shop
//
//  Created by akrio on 2017/4/24.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import SwiftyJSON
import Moya_SwiftyJSONMapper
/// 航班仓位信息
struct CabinListItem : ALSwiftyJSONAble{
    /// 唯一标识
    let id:String
    /// 价格
    let price:Int
    /// 税费
    let tax:Int
    /// 舱位类型
    let cabinTypeText:String
    /// 舱位折扣
    let discount:Double
    /// 剩余票数
    let num:String
    /// 退改签规则
    let ei:String
    /// 退改签规则
    let ifProPrice:Bool
    init(jsonData:JSON){
        self.id = jsonData["id"].stringValue
        self.price = jsonData["price"].intValue
        self.tax = jsonData["tax"].intValue
        self.ei = jsonData["ei"].stringValue.replacingOccurrences(of: "<br>", with: "\r\n")
        self.cabinTypeText = jsonData["cabinTypeText"].stringValue
        self.discount = jsonData["discount"].doubleValue
        self.num = jsonData["num"].stringValue
        self.ifProPrice = jsonData["ifProPrice"].boolValue
    }
}
