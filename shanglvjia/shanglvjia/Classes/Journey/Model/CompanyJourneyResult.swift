//
//  JourneyResult.swift
//  shop
//
//  Created by TBI on 2017/6/15.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import SwiftyJSON
import Moya_SwiftyJSONMapper
import SwiftDate

struct CompanyJourneyCountResult: ALSwiftyJSONAble {
    /// 计划中
    let planning:Int
    /// 审批中
    let waitForapprove:Int
    /// 待定妥
    let waitForTicket:Int
    /// 已定妥
    let ticketed:Int
    /// 待审批
    let approving:Int
    
    init(jsonData result:JSON){
        self.planning = result["planning"].intValue
        self.waitForapprove = result["waitForapprove"].intValue
        self.waitForTicket = result["waitForTicket"].intValue
        self.ticketed = result["ticketed"].intValue
        self.approving = result["approving"].intValue
    }
}

struct CompanyJourneyResult: ALSwiftyJSONAble {
    /// 出行日期
    let travelData:DateInRegion
    /// 行程类型 1机票 2酒店 3火车票 4专车
    let type:Int
    /// 关联订单号
    let orderNo:String
    /// 机票信息
    let  flight:FlightJourneyItem
    /// 酒店信息
    let  hotel:HotelJourneyItem
    ///  火车票
    let  train:TrainJourneyItem
    ///  专车
    let  car:CarJourneyItem
    
    init(jsonData result:JSON){
        self.travelData = result["travelData"].dateFormat(.unix) 
        self.type = result["type"].intValue
        self.orderNo = result["orderNo"].stringValue
        self.flight = FlightJourneyItem(jsonData: result["flight"])
        self.hotel = HotelJourneyItem(jsonData: result["hotel"])
        self.train = TrainJourneyItem(jsonData: result["train"])
        self.car = CarJourneyItem(jsonData: result["car"])
    }
    
    ///机票行程
    struct FlightJourneyItem: ALSwiftyJSONAble{
        /// 出发日期
        let departureDate:DateInRegion
        
        /// 出发机场
        let departureAirport:String
        
        /// 出发城市
        let departureCity:String
        
        /// 到达日期
        let arriveDate:DateInRegion
        
        /// 到达机场
        let arriveAirport:String
        
        /// 到达城市
        let arriveCity:String
        
        /// 航班号
        let flightNo:String
        
        // 航空公司名称
        let companyName:String
        
        init(jsonData result:JSON){
            self.departureDate = result["departureDate"].dateFormat(.unix) 
            self.arriveDate = result["arriveDate"].dateFormat(.unix) 
            self.departureAirport = result["departureAirport"].stringValue
            self.departureCity = result["departureCity"].stringValue
            self.arriveAirport = result["arriveAirport"].stringValue
            self.arriveCity = result["arriveCity"].stringValue
            self.flightNo = result["flightNo"].stringValue
            self.companyName = result["companyName"].stringValue
        }
    }
    //酒店行程
    struct HotelJourneyItem: ALSwiftyJSONAble{
        /// 酒店名称
        let hotelName:String
        
        /// 房型名称
        let roomName:String
        
        /// 到店日期
        let arriveDate:DateInRegion
        
        /// 离店日期
        let leaveDate:DateInRegion
        
        /// 联系电话
        let contactNumber:String
        
        /// 酒店地址
        let address:String
        
        init(jsonData result:JSON){
            self.arriveDate = result["arriveDate"].dateFormat(.unix)
            self.leaveDate = result["leaveDate"].dateFormat(.unix)
            self.hotelName = result["hotelName"].stringValue
            self.roomName = result["roomName"].stringValue
            self.contactNumber = result["contactNumber"].stringValue
            self.address = result["address"].stringValue
        }

    }
    
    
    //火车票行程
    struct TrainJourneyItem: ALSwiftyJSONAble{
        /// 车次
        let checi:String
        /// 乘车日期
        let trainDate:String
        /// 出发日期
        let startTime:DateInRegion
        /// 到达日期
        let endTime:DateInRegion
        /// 出发站中文名
        let fromStationNameCn:String
        /// 到达站中文名
        let toStationNameCn:String
        /// 座次编码
        let siteCode:String
        /// 车票座位信息
        let siteInfo:String
        
        init(jsonData result:JSON){
            self.startTime = result["startTime"].dateFormat(.unix)
            self.endTime = result["endTime"].dateFormat(.unix)
            self.checi = result["checi"].stringValue
            self.trainDate = result["trainDate"].stringValue
            self.fromStationNameCn = result["fromStationNameCn"].stringValue
            self.toStationNameCn = result["toStationNameCn"].stringValue
            self.siteCode = result["siteCode"].stringValue
            self.siteInfo = result["siteInfo"].stringValue
        }
        
    }
    
    
    //专车行程
    struct CarJourneyItem: ALSwiftyJSONAble{
      
        /// 订单类型
        let  orderType:OrderCarTypeEnum
        /// 车型
        let carType:String
        /// 起始地点
        let startAddress:String
        /// 起始时间
        let startTime:DateInRegion
        /// 到达地点
        let endAddress:String
        /// 预订到达时间
        let endTime:DateInRegion
        /// 司机名称
        let driverName:String
        /// 司机手机号
        let driverPhone:String
        /// 司机车牌号
        let driverNO:String
        
        init(jsonData result:JSON){
            self.startTime = result["startTime"].dateFormat(.unix)
            self.endTime = result["endTime"].dateFormat(.unix)
            self.orderType =  OrderCarTypeEnum(rawValue: result["orderType"].stringValue) ?? .unknow
            self.carType = result["carType"].stringValue
            self.startAddress = result["startAddress"].stringValue
            self.endAddress = result["endAddress"].stringValue
            self.driverName = result["driverName"].stringValue
            self.driverPhone = result["driverPhone"].stringValue
            self.driverNO = result["driverNO"].stringValue
        }
        
    }
}
