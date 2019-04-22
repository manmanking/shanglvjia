//
//  RoomModel.swift
//  shop
//
//  Created by manman on 2017/7/20.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class RoomModel: NSObject {

    //酒店ID
    var  hotelId:String = ""
    //酒店价格
    var lowRate:Int = 0
    //房型信息
    //房间ID
    var  roomId:String = ""
    //房间名称
    var  roomName:String = ""
    //床
    var  bedType:String = ""
    //图片
    var  imgUrl:String = ""
    //大图
    var  imgBigUrl:String = ""
    //房间类型ID
    var  ratePlanId:Int  = 0
    //含双早
    var  ratePlanName:String?
    //含双早
    var  status:Bool?
    
    var  oHotelNightlyRatesMap:Dictionary<String, Any>?

    var roomTypeId:String?
    //平均价格
    var  averageRate:Float?
    //总价
    var  totalRate:Float?

    //担保信息 
    //开始日期
    var  startTime:String?
    //描述
    var  guaranteeRuleDescription:String?
    //担保规则编号
    var  guranteeRuleId:Float?
    //日期类型 CheckInDay 入住日期 StayDay 在店日期
    var  dateType:String = ""
    
    var  startDate:NSInteger = 0
    
    var  endDate:NSInteger = 0
    //周有效天数
    var  weekSet:String = ""
    //是否到店时间担保
    var  timeGuarantee:Bool?
    //结束日期
    var  endTime:String = ""
    //是否房量担保
    var  amountGuarantee:Bool?
    //担保的房间数
    var  amount:Int?
    //担保类型  FirstNightCost 为首晚房费担保 FullNightCost 为全额房费担保
    var  guaranteeType:String?
    
    
    
}








