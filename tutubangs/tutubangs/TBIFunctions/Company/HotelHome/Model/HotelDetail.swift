//
//  HotelDetail.swift
//  shop
//
//  Created by akrio on 2017/4/26.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import Moya_SwiftyJSONMapper
import SwiftyJSON
import SwiftDate


struct OHotel {
    
    var oHotel:HotelDetail?
    var nowPay:Bool?
    var hotelCode:String?
    
    
}


struct HotelDetail {
    //酒店ID
    var  hotelId:String?
    //酒店价格
    var lowRate:Int?
    //酒店详情
    var detail:Detail?
    //房型信息
    var hotelRooms:[HotelRoom]?
    
    
    //酒店详情
    struct Detail{
        //图片列表
        var  hotelImage:[String]?
        //酒店信息
        var  features:String?
        //星级
        var  category:String?
        //酒店地址
        var  address:String?
        // 酒店描述
        var  description:String?
        // 酒店商圈
        var  district:String?
        //手机号
        var  phone:String?
        //城市编码
        var  cityId:String?
        //星级
        var  starRate:String?
        //酒店名称
        var  name:String?
        //周边交通
        var  traffic:String?
        //便利设施
        var  generalAmenities:String?

        
    }
    //房间
    struct HotelRoom{
        //房间ID
        var  roomId:String?
        //房间名称
        var  roomName:String?
        //床
        var  bedType:String?
        //图片
        var  imgUrl:String?
        //大图
        var  imgBigUrl:String?
        //各种类型房
        var  oHotelRatePlans:[OHotelRatePlan]?
        
        
    }
    //各种类型的房子
    struct OHotelRatePlan{
        //房间类型ID
        var  ratePlanId:Int?
        //含双早
        var  ratePlanName:String?
        //含双早
        var  status:Bool?
        
        var roomTypeId:String?
        
        //平均价格
        var  averageRate:Float?
        //总价
        var  totalRate:Float?
        //每天的价格
        var  oHotelNightlyRatesMap:Dictionary<String, Any>?//[String:[String:[String:String]]]?
        //担保信息
        var  oHotelGuaranteeRuleList:[OHotelGuaranteeRuleList]?
        
    }
    
    /**
     * 担保信息 TODO:待补充注释
     */
    struct OHotelGuaranteeRuleList{
        //开始日期
        var  startTime:String?
        //描述
        var  description:String?
        //担保规则编号
        var  guranteeRuleId:Float?
        //日期类型 CheckInDay 入住日期 StayDay 在店日期
        var  dateType:String?
        
        var  startDate:NSInteger?
        
        var  endDate:NSInteger?
        
        //周有效天数
        var  weekSet:String?
        //是否到店时间担保
        var  timeGuarantee:Bool?
        //结束日期
        var  endTime:String?
        //是否房量担保
        var  amountGuarantee:Bool?
        //担保的房间数
        var  amount:Int?
        //担保类型  FirstNightCost 为首晚房费担保 FullNightCost 为全额房费担保
        var  guaranteeType:String?
        
       
    }
    
}



extension OHotel:ALSwiftyJSONAble
{
    init (jsonData result:JSON){
        self.oHotel =  HotelDetail(jsonData:result["oHotel"])
        self.nowPay = result["nowPay"].boolValue
        self.hotelCode = result["hotelCode"].stringValue
    }
    
    
    
}

extension HotelDetail:ALSwiftyJSONAble{
    
    init (jsonData result:JSON){
        self.hotelId = result["hotelId"].string
        self.lowRate = result["lowRate"].int
        self.detail =  Detail(jsonData:result["hotelDetail"])
        self.hotelRooms = result["hotelRooms"].arrayValue.map{HotelRoom(jsonData:$0)}
    }
   
    
}

extension HotelDetail.Detail:ALSwiftyJSONAble{
    
    init (jsonData result:JSON){
        //图片列表
        self.name = result["name"].string
        self.address = result["address"].string
        self.phone = result["phone"].string
        self.features = result["features"].string
        self.description = result["description"].string
        self.traffic = result["traffic"].string
        self.generalAmenities = result["generalAmenities"].string
        self.features = result["features"].string
        self.hotelImage = result["hotelImage"].arrayValue.map{$0.stringValue}
        
    }
}

extension HotelDetail.HotelRoom:ALSwiftyJSONAble{
    
    init (jsonData result:JSON){
        //各种类型房
        //var  oHotelRatePlans:[OHotelRatePlan]?
        
        self.roomId = result["roomId"].string
        self.roomName = result["roomName"].string
        self.bedType = result["bedType"].string
        self.imgUrl = result["imgUrl"].string
        self.imgBigUrl = result["imgBigUrl"].string
        self.oHotelRatePlans = result["oHotelRatePlans"].arrayValue.map{HotelDetail.OHotelRatePlan(jsonData:$0)}
        
    }
}


extension HotelDetail.OHotelRatePlan:ALSwiftyJSONAble{
    
    init (jsonData result:JSON){
        
        //图片列表
        self.ratePlanId = result["ratePlanId"].int
        self.ratePlanName = result["ratePlanName"].string
        self.averageRate = result["averageRate"].float
        self.roomTypeId = result["roomTypeId"].string
        self.status = result["status"].boolValue
        self.totalRate = result["totalRate"].float
        self.oHotelNightlyRatesMap = result["oHotelNightlyRatesMap"].dictionary
        self.oHotelGuaranteeRuleList =  result["oHotelGuaranteeRuleList"].arrayValue.map{HotelDetail.OHotelGuaranteeRuleList(jsonData:$0)}

    }
}

extension HotelDetail.OHotelGuaranteeRuleList:ALSwiftyJSONAble{
    
    init (jsonData result:JSON){
        self.startTime = result["startTime"].string
        self.description = result["description"].string
        self.guranteeRuleId = result["guranteeRuleId"].float
        self.dateType = result["dateType"].string
        self.weekSet = result["weekSet"].string
        self.timeGuarantee = result["timeGuarantee"].bool
        self.endTime = result["endTime"].string
        self.amountGuarantee = result["amountGuarantee"].bool
        self.amount = result["amount"].int
        self.guaranteeType = result["guaranteeType"].string
    }
}

