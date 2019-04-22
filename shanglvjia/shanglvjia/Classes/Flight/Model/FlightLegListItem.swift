//
//  FlightLegListItem.swift
//  shop
//
//  Created by akrio on 2017/4/28.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import SwiftyJSON
import Moya_SwiftyJSONMapper
/// 航班航段信息
struct FlightLegListItem :ALSwiftyJSONAble{
    /// 到达日期
    let arriveDate:String
    /// 到达航站楼
    let arriveTerminal:String
    /// 到达时间
    let arriveTime:String
    /// 到达机场文字
    let arriveStnTxt:String
    /// 到达城市
    let arriveCity:String
    /// 起飞日期
    let takeOffDate:String
    /// 起飞机场文字
    let takeOffStnTxt:String
    /// 起飞城市
    let takeOffCity:String
    /// 起飞机场航站楼
    let takeOffTerminal:String
    /// 起飞机场时间HHmm
    let takeOffTime:String
    /// 运营航空公司代码
    let marketAirlineCode:String
    /// 运营航班号
    let marketFlightNo:String
    /// 运营航空公司中文简写
    let marketAirlineShort:String
    /// 运营飞机名字
    let marketFlightName:String
    /// 承运航空公司代码
    let carriageAirlineCode:String
    /// 承运航班号
    let carriageFlightNo:String
    /// 承运航空公司文字
    let carriageAirlineShort:String
    /// 承运航班飞机名字
    let carriageFlightName:String
    init(jsonData:JSON){
        //parameters[0].replacingOccurrences(of: " 00:00:00", with: time)
        self.arriveDate = jsonData["arriveDate"].stringValue
        self.arriveTerminal = jsonData["arriveTerminal"].stringValue
        self.arriveTime = jsonData["arriveTime"].stringValue
        self.arriveCity = jsonData["arriveCity"].stringValue
        if jsonData["arriveStnTxt"].stringValue.characters.count > 6 {
            self.arriveStnTxt = jsonData["arriveStnTxt"].stringValue.replacingOccurrences(of: self.arriveCity, with: "")
        }else {
            self.arriveStnTxt = jsonData["arriveStnTxt"].stringValue
        }
        
        
        self.takeOffDate = jsonData["takeOffDate"].stringValue
        self.takeOffTerminal = jsonData["takeOffTerminal"].stringValue
        self.takeOffCity = jsonData["takeOffCity"].stringValue
        self.takeOffTime = jsonData["takeOffTime"].stringValue
        if jsonData["takeOffStnTxt"].stringValue.characters.count > 6 {
            self.takeOffStnTxt = jsonData["takeOffStnTxt"].stringValue.replacingOccurrences(of: self.takeOffCity, with: "")
        }else {
            self.takeOffStnTxt = jsonData["takeOffStnTxt"].stringValue
        }
        
        
        self.marketAirlineCode = jsonData["marketAirlineCode"].stringValue
        self.marketFlightNo = jsonData["marketFlightNo"].stringValue
        self.marketAirlineShort = jsonData["marketAirlineShort"].stringValue
        self.marketFlightName = jsonData["marketFlightName"].stringValue
        
        self.carriageAirlineCode = jsonData["carriageAirlineCode"].stringValue
        self.carriageFlightNo = jsonData["carriageFlightNo"].stringValue
        self.carriageAirlineShort = jsonData["carriageAirlineShort"].stringValue
        self.carriageFlightName = jsonData["carriageFlightName"].stringValue
    }
}
