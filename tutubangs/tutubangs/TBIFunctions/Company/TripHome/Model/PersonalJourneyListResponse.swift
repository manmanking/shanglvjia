//
//  PersonalJourneyListResponse.swift
//  shanglvjia
//
//  Created by manman on 2018/5/15.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import SwiftyJSON
import Moya_SwiftyJSONMapper

class PersonalJourneyListResponse: NSObject,ALSwiftyJSONAble {

    var count:NSInteger = 0
    var journeyInfos:[PersonalJourneyInfo] = Array() // (Array[], optional),
    var total:NSInteger = 0
    
    override init() {
        
    }
    
    required init?(jsonData: JSON) {
        count = jsonData["count"].intValue
        journeyInfos = jsonData["journeyInfos"].arrayValue.map{PersonalJourneyInfo.init(jsonData: $0)!}
        total = jsonData["total"].intValue
    }
    
    
    class PersonalJourneyInfo: NSObject ,ALSwiftyJSONAble{
        
        /// , optional): 机票航程信息 ,
        var airInfo:PersonalJourneyAirInfo?
        
        /// , optional): 专车信息 ,
        var carInfo:PersonalJourneyCarInfo?
        
        /// , optional): 酒店信息 ,
        var hotelInfo:PersonalJourneyHotelInfo?
        
        /// , optional): 火车票信息 ,
        var trainInfo:PersonalJourneyTrainInfo?
        
        ///  (string, optional): 订单号 ,
        var orderId:String = ""
        
        ///  (string, optional): 关联订单号 ,
        var orderNo:String = ""
        
        ///  (integer, optional): 出行日期 ,
        var travelData:NSInteger = 0
        
        /// 行程类型（1：机票，2：酒店，3：火车票，4：专车）
        var type:NSInteger = 1
        
        override init() {
            
        }
        required init?(jsonData: JSON) {
            orderId = jsonData["orderId"].stringValue
            orderNo = jsonData["orderNo"].stringValue
            travelData = jsonData["travelData"].intValue
            type = jsonData["type"].intValue
            if type == 1 {
                airInfo = PersonalJourneyAirInfo.init(jsonData:jsonData["airInfo"])
            }
            if type == 2 {
                hotelInfo = PersonalJourneyHotelInfo.init(jsonData:jsonData["hotelInfo"])
            }
            if type == 3 {
                trainInfo = PersonalJourneyTrainInfo.init(jsonData:jsonData["trainInfo"])
            }
            if type == 4 {
                carInfo = PersonalJourneyCarInfo.init(jsonData:jsonData["carInfo"])
            }
        }
        
        
        
    }
    
    
    class PersonalJourneyAirInfo: NSObject ,ALSwiftyJSONAble{
        
        ///  (string, optional): 到达机场 ,
        var arriveAirport:String = ""
        
        ///  (string, optional): 到达城市 ,
        var arriveCity:String = ""
        
        ///  (integer, optional): 到达日期 ,
        var arriveDate:NSInteger = 0
        
        ///  (string, optional): 航空公司名称 ,
        var companyName:String = ""
        
        ///  (string, optional): 出发机场 ,
        var departureAirport:String = ""
        
        ///  (string, optional): 出发城市 ,
        var departureCity:String = ""
        
        ///  (integer, optional): 出发日期 ,
        var departureDate:NSInteger = 0
        
        ///  (string, optional): 航班号
        var flightNo:String = ""
        
        
        override init() {
            
        }
        required init?(jsonData: JSON) {
            arriveAirport = jsonData["arriveAirport"].stringValue
            arriveCity = jsonData["arriveCity"].stringValue
            arriveDate = jsonData["arriveDate"].intValue
            companyName = jsonData["companyName"].stringValue
            departureAirport = jsonData["departureAirport"].stringValue
            departureCity = jsonData["departureCity"].stringValue
            departureDate = jsonData["departureDate"].intValue
            flightNo = jsonData["flightNo"].stringValue
        }
        
        
    }
    class PersonalJourneyCarInfo: NSObject,ALSwiftyJSONAble {
        
        ///  (string, optional): 车型 ,
        var carType:String = ""
        
        ///  (string, optional): 司机车牌号 ,
        var driverNO:String = ""
        
        ///  (string, optional): 司机名称 ,
        var driverName:String = ""
        
        ///  (string, optional): 司机手机号 ,
        var driverPhone:String = ""
        
        ///  (string, optional): 到达地点 ,
        var endAddress:String = ""
        
        ///  (integer, optional): 预订到达时间 ,
        var endTime:NSInteger = 0
        
        ///  (string, optional): 用车类型：1.接机；2.送机；99.预约用车 ,
        var orderType:Int = 1
        
        ///  (string, optional): 起始地点 ,
        var startAddress:String = ""
        
        ///  (integer, optional): 起始时间
        var startTime:NSInteger = 0
        
        override init() {
            
        }
        required init?(jsonData: JSON) {
            carType = jsonData["carType"].stringValue
            driverNO = jsonData["driverNO"].stringValue
            driverName = jsonData["driverName"].stringValue
            driverPhone = jsonData["driverPhone"].stringValue
            endAddress = jsonData["endAddress"].stringValue
            endTime = jsonData["endTime"].intValue
            orderType = jsonData["orderType"].intValue
            startAddress = jsonData["startAddress"].stringValue
            startTime = jsonData["startTime"].intValue
        }
        
        
    }
    class PersonalJourneyHotelInfo: NSObject ,ALSwiftyJSONAble{
        
        ///  (string, optional): 酒店地址 ,
        var address:String = ""
        
        ///  (integer, optional): 到店日期 ,
        var arriveDate:NSInteger = 0
        
        ///  (string, optional): 联系电话 ,
        var contactNumber:String = ""
        
        ///  (string, optional): 酒店名称 ,
        var hotelName:String = ""
        
        ///  (integer, optional): 离店日期 ,
        var leaveDate:NSInteger = 0
        
        ///  (string, optional): 房型名称
        var roomName:String = ""
        
        
        override init() {
            
        }
        required init?(jsonData: JSON) {
            address = jsonData["address"].stringValue
            arriveDate = jsonData["arriveDate"].intValue
            contactNumber = jsonData["contactNumber"].stringValue
            hotelName = jsonData["hotelName"].stringValue
            leaveDate = jsonData["leaveDate"].intValue
            roomName = jsonData["roomName"].stringValue
        }
        
    }
    
    
    class PersonalJourneyTrainInfo: NSObject ,ALSwiftyJSONAble{
        
        ///  (string, optional): 车次 ,
        var checi:String = ""
        
        ///  (integer, optional): 到达日期 2015-07-01 12:59:59 ,
        var endTime:NSInteger = 0
        
        ///  (string, optional): 出发站中文名 ,
        var fromStationNameCn:String = ""
        
        ///  (string, optional): 座次编码 ,
        var siteCode:String = ""
        
        ///  (string, optional): 车票座位信息 ,
        var siteInfo:String = ""
        
        ///  (integer, optional): 出发日期 2015-07-01 12:59:59 ,
        var startTime:NSInteger = 0
        
        ///  (string, optional): 到达站中文名 ,
        var toStationNameCn:String = ""
        
        ///  (string, optional): 乘车日期
        var trainDate:String = ""
        
        
        override init() {
            
        }
        required init?(jsonData: JSON) {
            checi = jsonData["checi"].stringValue
            endTime = jsonData["endTime"].intValue
            fromStationNameCn = jsonData["fromStationNameCn"].stringValue
            siteCode = jsonData["siteCode"].stringValue
            siteInfo = jsonData["siteInfo"].stringValue
            startTime = jsonData["startTime"].intValue
            toStationNameCn = jsonData["toStationNameCn"].stringValue
            trainDate = jsonData["trainDate"].stringValue
        }
        
    }

    
    
}
