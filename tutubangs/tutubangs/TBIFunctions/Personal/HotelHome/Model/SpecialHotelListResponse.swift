//
//  SpecialHotelListResponse.swift
//  shanglvjia
//
//  Created by manman on 2018/7/31.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON

class SpecialHotelListResponse: NSObject,ALSwiftyJSONAble{
    
    var count:String = ""
    var pageNo:String = ""
    var pageSize:String = ""
    var specialHotelList:[SpecialHotelInfo] = Array()
    ///展开收起
    var isMore : Bool = false
    override init() {
    }
    
    required init?(jsonData: JSON) {
        count = jsonData["count"].stringValue
        pageNo = jsonData["pageNo"].stringValue
        pageSize = jsonData["pageSize"].stringValue
        specialHotelList = jsonData["result"].arrayValue.map{SpecialHotelInfo.init(jsonData: $0)!}
    }
    
    
    
    class SpecialHotelInfo: NSObject ,ALSwiftyJSONAble{
        /// : "海淀区永丰科技园丰智东路5号(近永丰派出所)",
        var address:String = ""
        var cover:String = ""
        var elongId:String = ""
        var hotelDesc:String = ""
        var cityId:String = ""
        var cityName:String = ""
        var facilitiesV2List:[String] = Array()
        var groupCode:String = ""
        var hotelFax:String = ""
        var hotelId:String = ""
        var hotelInfosList:[String] = Array()
        var hotelName:String = ""
        var needConfirm:String = ""
        var orderNum:String = ""
        ///新加的酒店描述字段
        var distName:String = ""
        var hotelfax:String = ""
        var networkDesc:String = ""
        var openTime:String = ""
        var parkDesc:String = ""
        var renovationTime:String = ""
        var arivalTime:String = ""
        var depTime:String = ""
        var brandName:String = ""
        var bussinessName:String = ""
        var conferenceAmenities:String = ""
        var diningAmenities:String = ""
        var trafficDesc:String = ""
        
        var trafficInfo:String = ""
        /// 1预付 2 现付
        var payType:String = ""
        var preSaleDay:String = ""
        var pricetype:String = ""
        /// 1 国内 2 国际
        var regionType:String = ""
        var saleRate:String = ""
        var starRate:String = ""
        var businessZone:String = ""
        var score:String = ""
        var lat:String = ""
        var lon:String = ""
        var latitudeBaidu:String = ""
        var longitudeBaidu:String = ""
        var latitudeGoogle:String = ""
        var longitudeGoogle:String = ""
        override init() {
            
        }
        
        required init?(jsonData: JSON) {
            cityId = jsonData["cityId"].stringValue
            address = jsonData["address"].stringValue
            cover = jsonData["cover"].stringValue
            cityName = jsonData["cityName"].stringValue
            hotelFax = jsonData["hotelFax"].stringValue
            hotelDesc = jsonData["hotelDesc"].stringValue
            elongId = jsonData["elongId"].stringValue
            facilitiesV2List = jsonData["facilitiesV2List"].arrayValue.map{$0.stringValue }
            groupCode = jsonData["groupCode"].stringValue
            hotelId = jsonData["hotelId"].stringValue
            hotelInfosList = jsonData["hotelInfosList"].arrayValue.map{$0["picUrl"].stringValue}
            hotelName = jsonData["hotelName"].stringValue
            needConfirm = jsonData["needConfirm"].stringValue
            orderNum = jsonData["orderNum"].stringValue
            trafficInfo = jsonData["trafficInfo"].stringValue
            payType = jsonData["payType"].stringValue
            preSaleDay = jsonData["preSaleDay"].stringValue
            pricetype = jsonData["count"].stringValue
            saleRate = jsonData["saleRate"].stringValue
            starRate = jsonData["starRate"].stringValue
            businessZone = jsonData["businessZone"].stringValue
            score = jsonData["score"].stringValue
            
            latitudeBaidu = jsonData["latitudeBaidu"].stringValue
            longitudeBaidu = jsonData["longitudeBaidu"].stringValue
            
            latitudeGoogle = jsonData["latitudeGoogle"].stringValue
            longitudeGoogle = jsonData["longitudeGoogle"].stringValue
            
            distName = jsonData["distName"].stringValue
            networkDesc = jsonData["networkDesc"].stringValue
            openTime = jsonData["openTime"].stringValue
            hotelfax = jsonData["hotelfax"].stringValue
            parkDesc = jsonData["parkDesc"].stringValue
            renovationTime = jsonData["renovationTime"].stringValue
            arivalTime = jsonData["arivalTime"].stringValue
            depTime = jsonData["depTime"].stringValue
            brandName = jsonData["brandName"].stringValue
            bussinessName = jsonData["bussinessName"].stringValue
            conferenceAmenities = jsonData["conferenceAmenities"].stringValue
            diningAmenities = jsonData["diningAmenities"].stringValue
            trafficDesc = jsonData["trafficDesc"].stringValue
            
        }
        
        
    }
    
    
   
    

}
