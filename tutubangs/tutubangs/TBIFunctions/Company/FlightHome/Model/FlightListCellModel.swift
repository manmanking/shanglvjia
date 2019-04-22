//
//  FlightListCellModel.swift
//  shop
//
//  Created by SLMF on 2017/4/28.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation

struct FlightListCellModel {
    //起飞时间
    var takeOffDate: String
    //到达时间
    var arriveDate: String
    //起飞机场
    var takeOffAirport: String
    //到达机场
    var arriveAirport: String
    //价格
    var price: String
    //是否违反政策
    var contrayPolicy: Int
    /// 是否直达航班
    var direct:Bool
    // 是否经停
    var stopOver: Bool
    // 中转城市
    var directCity: String
    //是否共享
    var share: Bool
    //航空公司编码
    var flightCode: String
    //航空公司名称
    var flightName: String
    //航班号
    var flightNo: String
    //
    var craftType: String
    //
    var flyDays: String
    
    init(takeOffDate: String, arriveDate: String, takeOffAirport: String, arriveAirport: String, price: String, contrayPolicy: Bool, stopOver: Bool, share: Bool, flightCode: String, flightName: String, flightNo: String, craftType: String, flyDays: String, direct: Bool,directCity: String) {
        self.takeOffDate = takeOffDate
        self.takeOffAirport = takeOffAirport
        self.arriveDate = arriveDate
        self.arriveAirport = arriveAirport
        self.price = price
        self.contrayPolicy = contrayPolicy ? 1 : 0
        self.stopOver = stopOver
        self.direct = direct
        self.share = share
        self.flightCode = flightCode
        self.flightName = flightName
        self.flightNo = flightNo
        self.craftType = craftType
        self.flyDays = flyDays
        self.directCity = directCity
    }
    
    init(takeOffDate: String, arriveDate: String, takeOffAirport: String, arriveAirport: String, price: String, stopOver: Bool, share: Bool, flightCode: String, flightName: String, flightNo: String, craftType: String, flyDays: String,direct: Bool,directCity:String) {
        self.takeOffDate = takeOffDate
        self.takeOffAirport = takeOffAirport
        self.arriveDate = arriveDate
        self.arriveAirport = arriveAirport
        self.price = price
        self.stopOver = stopOver
        self.direct = direct
        self.share = share
        self.flightCode = flightCode
        self.flightName = flightName
        self.flightNo = flightNo
        self.craftType = craftType
        self.flyDays = flyDays
        self.contrayPolicy = 2
        self.directCity = directCity
    }
    
}
