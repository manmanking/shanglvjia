//
//  FlightSVSearchConditionModel.swift
//  shop
//
//  Created by manman on 2018/2/1.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class FlightSVSearchConditionModel: NSObject,NSCoding{ //,NSMutableCopying,NSCopying
  

    
    /// 乘机人ID
    var travellerUids:String = ""
    
    var takeOffCity:String = ""
    
    var arriveCity:String = ""
    
    var needFilterPolicy:String = ""
    
    
    ///出发机场三字码
    var takeOffAirportCode:String = ""
    
    var takeOffAirportName:String = ""
    
    ///到达机场三字码
    var arriveAirportCode:String = ""
    var arriveAirportName:String = ""
    
    /// 最低价时间政策
    var lowestPriceInterval:NSInteger = 0
    
    /// 去程时间 时间戳 * 1000
    var departureDate:NSInteger = 0
    /// 回程时间 时间戳 * 1000
    var returnDate:NSInteger = 0
    
    /// 离店时间 "yyyy-MM-dd HH:mm:ss"
    var departureDateFormat:String = ""
    
    /// 入住时间  "yyyy-MM-dd HH:mm:ss"
    var returnDateFormat:String = ""
    
    
    /// 多程中。上一段的到达时间 毫秒
    var preArrTime:String = ""
    
    
    /// 类型 0单程,1往返程,2多程
    var type:NSInteger = 0
    
    //  记录当前行程 航段
    //  若类型为 单程 则 此航段 即为首航段 值为0
    //  若类型为 往返 则 此航段 航段 分为  去成航段 1 返程航段 2
    //  若类型为 多程 则 此航段  航段 分为 第一程 1   第二程 2 第三程 3 第四程 4
    
    var currentTripSection:NSInteger = 1
    // 记录多程航段 的最多航段 单程和往返 可以不考虑这个字段
    var maxTripInt:NSInteger = 1
    
    
    /// 是否存在  单程 多程  (往返 去程) 推荐 机票 信息 0 无。1 存在
    var hasRecommendFlightTrip:NSInteger = 0
    
    /// 是否存在 往返 返程 推荐机票信息  0 无。1 存在
    var  hasBackRecommendFlightTrip:NSInteger = 0
    
    
    ///  单程 多程  (往返 去程) 仓位信息是否违背 差旅政策  false 符合。true 违背
    var flightCabincontraryPolicy:Bool = false
    ///(往返 返程程) 仓位信息是否违背 差旅政策  false 符合。true 违背
    var backFlightCabincontraryPolicy:Bool = false
    

    /// 差旅政策
    var travelPolicyId:String = ""
    
    /// 组织代码
    var corpCode:String = ""
    
    /// 改签的 航班信息
    
    /// 指定航司
    var specialFlightCode:String = ""
    
    /// 指定 订单 重新预定
    var specialOrderId:String = ""
    
    var requireDetail:String = ""
    
    var orderStatus:String = ""
    
    var orderNo:String = ""
    
    var lowestPrice:String = ""
    
    
    override init() {
        
    }
    
//    func mutableCopy(with zone: NSZone? = nil) -> Any {
//        self.m
//    }
//
//
//    func copy(with zone: NSZone? = nil) -> Any {
//
//    }
    func encode(with aCoder: NSCoder) {
        self.mj_encode(aCoder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.mj_decode(aDecoder)
    }
    
    
    
}
