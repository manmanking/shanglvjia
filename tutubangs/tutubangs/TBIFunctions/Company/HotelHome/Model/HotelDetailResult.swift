//
//  HotelDetailResult.swift
//  shanglvjia
//
//  Created by manman on 2018/5/2.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON


class HotelDetailResult: NSObject,ALSwiftyJSONAble {

    var hotelDetailInfo:HotelDetailInfo = HotelDetailInfo()
    var hotelRoomInfoList:[HotelRoomInfo] = Array()
    
    
    override init() {
        
    }
    
    required init?(jsonData: JSON) {
        self.hotelDetailInfo = HotelDetailInfo.init(jsonData: jsonData["hotelDetailInfo"])!
        self.hotelRoomInfoList = jsonData["hotelRoomInfoList"].arrayValue.map{HotelRoomInfo.init(jsonData: $0)!}
        for element in self.hotelRoomInfoList {
            element.hotelElongId = hotelDetailInfo.hotelElongId
            element.hotelOwnId = hotelDetailInfo.hotelOwnId
            element.hotelName = hotelDetailInfo.hotelName
            element.hotelPhone = hotelDetailInfo.hotelPhone
        }
//        self.hotelRoomInfoList.forEach { (element) in
//            element.hotelElongId = hotelDetailInfo.hotelElongId
//        } //map{$0.hotelElongId = hotelDetailInfo.hotelElongId}
    }
    
    
    class HotelDetailInfo: NSObject,ALSwiftyJSONAble {
        
        var cityId:String = ""
        var cityName:String = ""
        var certInfos:String = ""
        var distance:String = ""
        var facilitiesV2List:[String] = Array()
        var hotelAddress:String = ""
        var hotelDesc:String = ""
        var trafficInfo:String = ""
        var hotelElongId:String = ""
        var hotelHistory:String = ""
        var hotelName :String = ""
        var hotelOwnId:String = ""
        var hotelPhone:String = ""
        var images:[String] = Array()
        var latitude:String = ""
        var longitude:String = ""
        var latitudeBaidu:String = ""
        var longitudeBaidu:String = ""
        var latitudeGoogle:String = ""
        var longitudeGoogle:String = ""
        var lowRate:String = ""
        
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
        
        override init() {
            
        }
        
        required init?(jsonData: JSON) {
            
            self.cityId = jsonData["cityId"].stringValue
            self.cityName = jsonData["cityName"].stringValue
            self.certInfos = jsonData["certInfos"].stringValue
            self.distance = jsonData["distance"].stringValue
            self.facilitiesV2List = jsonData["facilitiesV2List"].arrayValue.map{$0.stringValue}
            self.hotelAddress = jsonData["hotelAddress"].stringValue
            self.hotelDesc = jsonData["hotelDesc"].stringValue
            self.trafficInfo = jsonData["trafficInfo"].stringValue
            self.hotelElongId = jsonData["hotelElongId"].stringValue
            self.hotelHistory = jsonData["hotelHistory"].stringValue
            self.hotelName = jsonData["hotelName"].stringValue
            self.hotelOwnId = jsonData["hotelOwnId"].stringValue
            self.hotelPhone = jsonData["hotelPhone"].stringValue
            self.images = jsonData["images"].arrayValue.map{$0.stringValue}
            self.latitude = jsonData["latitude"].stringValue
            self.longitude = jsonData["longitude"].stringValue
            self.latitudeBaidu = jsonData["latitudeBaidu"].stringValue
            self.longitudeBaidu = jsonData["longitudeBaidu"].stringValue
            self.latitudeGoogle = jsonData["latitudeGoogle"].stringValue
            self.longitudeGoogle = jsonData["longitudeGoogle"].stringValue
            self.lowRate = jsonData["lowRate"].stringValue
            
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
    
    class GuaranteeRuleInfo:NSObject,ALSwiftyJSONAble{
        var amount:NSInteger = 0
        var amountGuarantee:Bool = false
        var gDescription: String = ""
        // "description":"担保条件：在18.03.07至18.06.09入住如果在18:00至次日06:00到店，需要您提供信用卡担保。客人入住日18:00点前可以变更取消，之后无法变更取消，如未入住，将扣除第一晚房费作为违约金。",
        var endTime:String = ""//:"06:00",
        var guaranteeTypeStr:String = "" //:"FirstNightCost",
        
        var startTime:String = ""//:"18:00",
        var timeGuarantee:Bool = false //":true,
        var tomorrow:Bool = false //":true
        
        override init() {
            
        }
        required init?(jsonData: JSON) {
            self.amount = jsonData["amount"].intValue
            self.endTime = jsonData["endTime"].stringValue
            self.gDescription = jsonData["gDescription"].stringValue
            self.guaranteeTypeStr = jsonData["guaranteeTypeStr"].stringValue
            self.startTime = jsonData["startTime"].stringValue
            self.timeGuarantee = jsonData["timeGuarantee"].boolValue
            self.tomorrow = jsonData["tomorrow"].boolValue
        }
    }
    
    
    
    class HotelRoomInfo: NSObject,ALSwiftyJSONAble {
        var hotelName:String = ""
        var hotelAddress:String = ""
        var hotelPhone:String = ""
        var bedType:String = ""
        var capacity:String = ""
        var cover:String = ""
        var coverBig:String = ""
        var roomElongId:String = ""
        var hotelRoomId:String = ""
        var hotelElongId:String = ""
        var hotelOwnId:String = ""
        var roomTypeId:String = ""
        var roomTypeName:String = ""
        /// 1 是国内 2 是国际
        var regionType:String = ""
        var ratePlanInfoList :[RatePlanInfo] = Array()
        /// 1预付 2 现付
        var payType:String = ""
        ///展开 默认
        var isFolderOpen:Bool = false
        
         var selectedPlanInfoIndex:NSInteger = 99// 默认数据
        
        override init() {
            
        }
        required init?(jsonData: JSON) {
            self.bedType = jsonData["bedType"].stringValue
            self.capacity = jsonData["capacity"].stringValue//
            self.cover = jsonData["cover"].stringValue
            self.roomTypeId = jsonData["roomTypeId"].stringValue
            self.coverBig = jsonData["coverBig"].stringValue
            self.roomElongId = jsonData["roomElongId"].stringValue
            self.hotelRoomId = jsonData["hotelRoomId"].stringValue
            self.roomTypeName = jsonData["roomTypeName"].stringValue
            regionType = jsonData["regionType"].stringValue
            self.payType = jsonData["payType"].stringValue
            self.ratePlanInfoList = jsonData["ratePlanInfoList"].arrayValue.map{RatePlanInfo.init(jsonData: $0)!}
        }
        
    }
    
    
   
    class RatePlanInfo: NSObject ,ALSwiftyJSONAble {
        var broadnet:String = ""
        var canBook:String = ""
        var corpCode:String = ""
        var guaranteeDesc:String = ""
        var guaranteeRuleInfo:GuaranteeRuleInfo = GuaranteeRuleInfo()
        var isGuarantee:String = ""
        var isTravelPolicy:String = ""
        var mealCount :String = ""
        var nightRateList:[NightRate] = Array()
        var payType:String = ""
        var rate:Float = 0
        var roomTypeId:String = ""
        var ratePlainId:String = ""
        var ratePlanName:String = ""
        var status:Bool = false
        var valueAdd:String = ""
        var refundDesc:String = ""
        ///发票类型数组
        var orderInvoiceBaseList:[InvoicesModel] = Array()
        override init() {
            
        }
        
        required init?(jsonData: JSON) {
            self.broadnet = jsonData["broadnet"].stringValue
            self.canBook = jsonData["canBook"].stringValue
            self.corpCode = jsonData["corpCode"].stringValue
            self.guaranteeDesc = jsonData["guaranteeDesc"].stringValue
            self.guaranteeRuleInfo = GuaranteeRuleInfo.init(jsonData: jsonData["guaranteeRuleInfo"])!
            self.isGuarantee = jsonData["isGuarantee"].stringValue
            self.isTravelPolicy = jsonData["isTravelPolicy"].stringValue
            self.mealCount = jsonData["mealCount"].stringValue
            self.nightRateList = jsonData["nightRateList"].arrayValue.map{NightRate.init(jsonData: $0)!}
            self.payType = jsonData["payType"].stringValue
            self.rate = jsonData["rate"].floatValue
            self.ratePlainId = jsonData["ratePlainId"].stringValue
            self.ratePlanName = jsonData["ratePlanName"].stringValue
            self.roomTypeId = jsonData["roomTypeId"].stringValue
            self.status = jsonData["status"].boolValue
            self.valueAdd = jsonData["valueAdd"].stringValue
            self.refundDesc = jsonData["refundDesc"].stringValue
            self.orderInvoiceBaseList = jsonData["orderInvoiceBaseList"].arrayValue.map{InvoicesModel.init(jsonData: $0)!}
        }
    }
    
    class InvoicesModel: NSObject,ALSwiftyJSONAble {
        var name:String = ""
        var value:String = ""
        required init?(jsonData: JSON) {
            name = jsonData["name"].stringValue
            value = jsonData["value"].stringValue
        }
    }
    
    
    class NightRate: NSObject,ALSwiftyJSONAble {
        var date:String = ""//:1525190400000,
        var memberRate:NSInteger = 0//:349,
        var status:Bool = false //":true
        
        override init() {
            
        }
        required init?(jsonData: JSON) {
            self.date = jsonData["date"].stringValue
            self.memberRate = jsonData["memberRate"].intValue
            self.status = jsonData["status"].boolValue
        }
    }
    
    
    /// 房间  房间的不同 配置 写入一个数据结构
    class HotelRoomPlan: NSObject {
        var hotelName:String = ""
        var bedType:String = ""
        var capacity:String = ""
        var cover:String = ""
        var coverBig:String = ""
        var hotelElongId:String = ""
        var hotelOwnId:String = ""
        var roomElongId:String = ""
        var roomTypeName:String = ""
        var ratePlanInfo:RatePlanInfo = RatePlanInfo()
    }
    
    
  
    
}
