//
//  CommercialFlightSearchForm.swift
//  shop
//
//  Created by SLMF on 2017/4/28.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation

//
struct CommercialFlightSearchForm: DictionaryAble {
    //出发机场三字码
    var takeOffAirportCode: String = ""
    //到达机场三字码
    var arriveAirportCode: String = ""
    
    //出发城市 or 机场名称
    var takeOffAirportName: String = ""
    //到达城市 or 机场名称
    var arriveAirportName: String = ""
    
    //出发时间（两个时间最少必填一个）
    var departureDates: Date? = nil
    //回程时间
    var returnDates: Date? = nil
    
    //出发时间（两个时间最少必填一个）
    var departureDate: String = ""
    //回程时间
    var returnDate: String = ""
    
    //上下几小时最低价区间
    var lowestPriceInterval: Int = 0
    //单程0、去程1、回程2
    var type: Int = 0
    //乘客uid
    var travellerUids: [String] = Array()
    
    
    init(takeOffAirportCode: String, arriveAirportCode: String,takeOffAirportName: String,arriveAirportName: String, type: Int, travellerUids: [String]) {
        self.takeOffAirportCode = takeOffAirportCode
        self.arriveAirportCode = arriveAirportCode
        self.takeOffAirportName = takeOffAirportName
        self.arriveAirportName = arriveAirportName
        self.type = type
        self.travellerUids = travellerUids
    }
    
}
