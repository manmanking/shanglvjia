//
//  HotelListItem.swift
//  shop
//
//  Created by akrio on 2017/4/24.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import Moya_SwiftyJSONMapper
import SwiftyJSON

/// 酒店列表实体
struct HotelListItem: ALSwiftyJSONAble{
    /// 酒店id
    let id:String!
    /// 酒店名称
    let name:String!
    /// 酒店星级
    let starRate:Int!
    /// 艺龙星级
    let category:Int!
    /// 酒店地址
    let address:String!
    /// 酒店电话
    let phone:String!
    /// 酒店设施
    let facilities:String!
    /// 酒店封面
    let imgUrl:String!
    /// 酒店类型
    let hotelType:String!
    /// 纬度
    let latitude:Double!
    /// 经度
    let longitude:Double!
    //(number): 差标 ,
    let accordTravel:Float!
    /// 酒店最低价格
    let lowRate:Int!
    init (jsonData jItem: JSON) {
        self.id = jItem["hotelId"].stringValue
        self.name = jItem["hotelName"].stringValue
        self.starRate = jItem["starRate"].intValue
        self.address = jItem["address"].stringValue
        self.phone = jItem["phone"].stringValue
        self.category = jItem["category"].intValue
        self.facilities = jItem["facilities"].stringValue
        self.imgUrl = jItem["imgUrl"].stringValue
        self.hotelType = jItem["hotelType"].stringValue
        self.latitude = jItem["lat"].doubleValue
        self.accordTravel = jItem["accordTravel"].floatValue
        self.longitude = jItem["lon"].doubleValue
        self.lowRate = jItem["lowRate"].intValue
    }
}
