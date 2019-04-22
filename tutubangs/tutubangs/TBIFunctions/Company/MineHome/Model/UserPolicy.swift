//
//  UserPolicy.swift
//  shop
//
//  Created by TBI on 2018/2/9.
//  Copyright © 2018年 TBI. All rights reserved.
//


import Foundation
import Moya_SwiftyJSONMapper
import SwiftyJSON

struct UserPolicy: ALSwiftyJSONAble{
    
    /// 违反差标时是否可预订（0：否，1：是)
    var anOrder:Bool
    /// 专车差标描述
    var carDesc:String
    /// 机票差标描述
    var flightDesc:String
    /// 酒店差标描述
    var hotelDesc:String
    /// 火车票差标描述
    var trainDesc:String
    
    init(jsonData:JSON){
        self.anOrder = jsonData["canOrder"].stringValue == "1" ? true:false
        self.carDesc = jsonData["carDesc"].stringValue.replacingOccurrences(of: "<br/>", with: "\r\n")
        self.flightDesc = jsonData["flightDesc"].stringValue.replacingOccurrences(of: "<br/>", with: "\r\n")
        self.hotelDesc = jsonData["hotelDesc"].stringValue.replacingOccurrences(of: "<br/>", with: "\r\n")
        self.trainDesc = jsonData["trainDesc"].stringValue.replacingOccurrences(of: "<br/>", with: "\r\n")
    }}
