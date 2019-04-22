//
//  CityModel.swift
//  shop
//
//  Created by akrio on 2017/4/26.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import Moya_SwiftyJSONMapper
import SwiftyJSON




/// 航班城市，酒店城市，航班机场公用实体
class City : DictionaryAble,ALSwiftyJSONAble {
    /// 名称
    let name:String
    /// 城市码
    let code:String
    /// 拼写
    let spell:String
    
    
    init(name:String,code:String,spell:String) {
        self.name = name
        self.code = code
        self.spell = spell
    }
    required init(jsonData:JSON){
        self.name = jsonData["name"].stringValue
        self.spell = jsonData["spell"].stringValue
        self.code = jsonData["code"].stringValue
    }
}
class AllCity : DictionaryAble{
    var cities:[City] = []
    init(_ cities:[City]) {
        self.cities = cities
    }
}
/// 城市分组实体
class CityGroup : DictionaryAble{
    /// 城市拼音缩写首字母
    let code:String
    var cities:[City] = []
    init(code:String,cities:[City]) {
        self.code = code
        self.cities = cities
    }
}
enum CitySearchType : String{
    case trainCity = "train_cits"
    case flightCity = "flight_city"
    case hotelCity = "hotel_city"
    case flightAirport = "flight_airport"
    case carAirport = "car_airports"
}
