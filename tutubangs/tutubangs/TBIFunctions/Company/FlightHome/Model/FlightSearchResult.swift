//
//  FlightSearchResult.swift
//  shop
//
//  Created by akrio on 2017/4/28.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import Moya_SwiftyJSONMapper
import SwiftyJSON
/// 航班查询结果
struct FlightSearchResult:ALSwiftyJSONAble {
    /// 起飞城市名
    let takeOffCity:String
    /// 到达城市名
    let arriveCity:String
    /// 去程起飞日期
    let departTakeoffDate:String
    /// 航班信息
    var flightList:[FlightListItem]
    
    /// 计算航班所有仓位
    var allCabin:[String] {
        return flightList.getAllCabin()
    }
    
    /// 计算搜索结果中的所有航空公司
    var allCompanyCode:[(code:String,name:String)] {
        return flightList.getAllCompanyCode()
    }
    
    /// 获取此次查询的最低价格
    var lowestPrice:Int {
        return flightList.getLowestPrice()
    }
    
    init(jsonData result:JSON){
        self.takeOffCity = result["takeOffCity"].stringValue
        self.arriveCity = result["arriveCity"].stringValue
        self.departTakeoffDate = result["departTakeoffDate"].stringValue
        self.flightList = result["flightList"].arrayValue.map{FlightListItem(jsonData: $0)}
    }
}
