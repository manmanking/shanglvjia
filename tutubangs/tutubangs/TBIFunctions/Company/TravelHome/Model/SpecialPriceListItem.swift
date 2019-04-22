//
//  FlightOrdersTableViewController.swift
//  shop
//
//  Created by akrio on 2017/6/28.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import SwiftDate
import Moya_SwiftyJSONMapper
import SwiftyJSON

/// 价格枚举
///
/// - adultPrice: 成人价格
/// - childBedPrice: 儿童占床价格
/// - childNobedPrice: 儿童不占价格
/// - singleRoomDifference: 单房差
enum PriceType:Int {
    case adultPrice = 1
    case childBedPrice = 2
    case childNobedPrice = 3
    case singleRoomDifference = 4
  
}

struct SpecialPriceListItem:ALSwiftyJSONAble {
    /// 特价产品价格id
    let priceId:String
    /// 销售日期
    let saleDate:DateInRegion
    /// 成人价格
    let adultPrice:Double
    /// 儿童占床价格
    let childBedPrice:Double
    /// 儿童不占床价格
    let childNobedPrice:Double
    /// 单房差、房间价、车辆价
    let singleRoomDifference:Double
    /// 特价产品价格状态 1.在售，2.售罄，3过期
    let status:Int
    /// 特价产品价格库存
    let stock:Int
    init(jsonData: JSON) {
        self.priceId = jsonData["priceId"].stringValue
        self.saleDate = jsonData["saleDate"].dateFormat(.custom("YYYY-MM-dd"))
        self.adultPrice = jsonData["adultPrice"].doubleValue
        self.childBedPrice = jsonData["childBedPrice"].doubleValue
        self.childNobedPrice = jsonData["childNobedPrice"].doubleValue
        self.singleRoomDifference = jsonData["singleRoomDifference"].doubleValue
        self.status = jsonData["status"].intValue
        self.stock = jsonData["stock"].intValue
    }
}
