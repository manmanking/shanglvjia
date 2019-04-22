//
//  HotelListNewModel.swift
//  shanglvjia
//
//  Created by manman on 2018/4/24.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON

class HotelListNewModel: NSObject,ALSwiftyJSONAble {

    var count:NSNumber = 0
    var sId:String = ""
    var result:[HotelListNewItem] = Array()
    var searchTimeStamp:String = ""
    override init() {
        
    }
    
    required init?(jsonData: JSON) {
        self.count = jsonData["count"].numberValue
        sId = jsonData["sId"].stringValue
        searchTimeStamp = jsonData[searchTimeStamp].stringValue
        self.result = jsonData["result"].arrayValue.map{HotelListNewItem.init(jsonData:$0)!}
    }
   
}

class HotelListNewItem: NSObject,ALSwiftyJSONAble{
    var corpCode:String = ""
    var cover:String = "" //:"http://pavo.elongstatic.com/i/Hotel120_120/0003kXxL.jpg",
    var coverBig:String = "" //:"http://pavo.elongstatic.com/i/API350_350/91b8c11dcdc84d84fbff346a8398530e.jpg",
    var distance:String = ""//:0,
    var facilitiesV2List:[String] = Array() //:Array[17],
    var hotelAddress:String = ""//:"崇文门外大街114号",
    var hotelId:String = ""//:"90286591",
    var hotelName:String = "" //:"桔子水晶酒店(北京崇文门店)",
    var hotelDesc:String = ""
    var trafficInfo:String = ""
    var hotelOwnId:String = "" //:"",
    var isGuarantee:String = ""//:2,
    /// 1 预付 2 现付
    var payType:String = ""
    
    var isTravelPolicy:String = ""//:0,
    var latitude:String = "" //:39.900466,
    var longitude:String = ""//:116.42569,
    var lowRate:String = "0"
    var score:String = ""//:6,
    var starRate:String = ""//:"0"
    var cityId:String = ""
    var businessZone:String = ""
    var mealDesc:String = ""
    
    override init() {
        
    }
    
    required init?(jsonData: JSON) {
        self.corpCode = jsonData["corpCode"].stringValue
        self.cover = jsonData["cover"].stringValue
        self.coverBig = jsonData["coverBig"].stringValue
        self.distance = jsonData["distance"].stringValue
        self.facilitiesV2List = jsonData["facilitiesV2List"].arrayValue.map{$0.stringValue}
        self.hotelAddress = jsonData["hotelAddress"].stringValue
        self.hotelId = jsonData["hotelId"].stringValue
        self.hotelName = jsonData["hotelName"].stringValue
        self.hotelOwnId = jsonData["hotelOwnId"].stringValue
        self.isGuarantee = jsonData["isGuarantee"].stringValue
        self.payType = jsonData["payType"].stringValue
        self.isTravelPolicy = jsonData["isTravelPolicy"].stringValue
        self.latitude = jsonData["latitude"].stringValue
        self.longitude = jsonData["longitude"].stringValue
        self.lowRate = jsonData["lowRate"].stringValue
        self.score = jsonData["score"].stringValue
        self.starRate = jsonData["starRate"].stringValue
        self.trafficInfo = jsonData["trafficInfo"].stringValue
        hotelDesc = jsonData["hotelDesc"].stringValue
        businessZone = jsonData["businessZone"].stringValue
        mealDesc = jsonData["mealDesc"].stringValue
        
    }
}

