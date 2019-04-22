//
//  PCommonFlightSVSearchModel.swift
//  shanglvjia
//
//  Created by tbi on 2018/8/8.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON

class PCommonFlightSVSearchModel: NSObject,ALSwiftyJSONAble,NSCoding {

    ///返程日历起始时间
    var returnDateFrom:String = ""
    ///返程日历结束时间
    var returnDateTo:String = ""
    ///去程日历开始时间
    var departureDateFrom:String = ""
    ///去程日历结束时间
    var departureDateFromTo:String = ""
    ///国际返程需要用
    var interCacheId:String = ""
    ///航班
    var airfares:[AirfareVO] = Array()
    
    /// 到达地名称 ,
    var arriveAirportName:String = ""
    
    /// 查询缓存ID
    var cacheId:String = ""
    
    /// 去程所有公司信息
    var companys:[AirlineCompanyVO] = Array()
    
    /// 出发地名称
    var takeOffAirportName:String = ""
    
    /// 出发日期
    var takeOffDate:NSInteger = 0
    
    /// 计算航班所有仓位
    var allCabin:[String] {
        return airfares.getAllCabin()
    }
    override required init() {
        super.init()
    }
    
    required init?(jsonData: JSON) {
        self.airfares = jsonData["airfares"].arrayValue.map{AirfareVO(jsonData:$0)!}
        self.arriveAirportName = jsonData["arriveAirportName"].stringValue
        self.cacheId = jsonData["cacheId"].stringValue
        self.companys = jsonData["companys"].arrayValue.map{AirlineCompanyVO(jsonData:$0)!}
        self.takeOffAirportName = jsonData["takeOffAirportName"].stringValue
        self.takeOffDate = NSInteger(jsonData["takeOffDate"].numberValue)
        
        self.returnDateFrom = jsonData["returnDateFrom"].stringValue
        self.returnDateTo = jsonData["returnDateTo"].stringValue
        self.departureDateFrom = jsonData["departureDateFrom"].stringValue
        self.departureDateFromTo = jsonData["departureDateFromTo"].stringValue
         self.interCacheId = jsonData["interCacheId"].stringValue
        
        // add by manman  on 2018-03-28
        // 这个方法 是否还有简单的方式完成 正在寻找
        // 将外层的Cacheid 赋值给 内层
        let airfaresCopy = self.airfares
        self.airfares.removeAll()
        for element in airfaresCopy {
            //element.cacheId = self.cacheId
            for cabinsElement in element.cabins {
                cabinsElement.flightCacheId = self.cacheId//element.cacheId

            }
            element.flightCacheId = self.cacheId
            for flightElement in element.flightInfos {
                flightElement.departureDateFrom = self.departureDateFrom
                flightElement.departureDateFromTo = self.departureDateFromTo
                flightElement.returnDateFrom = self.returnDateFrom
                flightElement.returnDateTo = self.returnDateTo
            }
            
            self.airfares.append(element)
        }
    }
    func encode(with aCoder: NSCoder) {
        self.mj_encode(aCoder)
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.mj_decode(aDecoder)
    }
    class AirfareVO: NSObject ,ALSwiftyJSONAble,NSCoding{
        
        /// 是否被推荐 替换 false 无推荐 true 有推荐
        var hasRecommendFlightTrip:Bool = false
        
        /// 推荐航班
        var recommendFlightTrips:AirfareVO?
        
        /// 是否被推荐 替换 false 无推荐 true 有推荐
        var hasRecommendFlightCabins:Bool = false
        
        /// 推荐仓位
        var recommendFlightCabin:CabinVO?
        
        /// 数量 ,
        var amount:NSInteger = 0
        
        ///  所有仓位机票信息 ,
        var cabins:[CabinVO] = Array()
        
        /// 选中的仓位信息
        var selectedCabinIndex:NSInteger?
        
        ///查询缓存ID
        var allCabincacheId:String = ""
        
        ///查询缓存ID
        var cacheId:String = ""
        
        var flightCacheId:String = ""
        
        /// 是否是国际 0 国内 1 国际
        var flightNation:String = ""
        
        //////行程类型（0：单程，1：往返）
        var flightTripType:String = ""
        
        /// 搜索产品ID
        var productId:String = ""
        
        /// 是否违反差旅政策 , true 违背。false 符合
        var contraryPolicy:Bool = false
        
        ///  是否直达
        var direct:Bool = false
        
        /// 折扣 ,
        var discount:NSNumber = 0
        
        /// 航班信息 ,
        var flightInfos:[FlightVO] = Array()
        
        /// ID ,
        var id:String = ""
        
        ///  价格 ,
        var price:NSNumber = 0
    
        /// 是否含有协议舱位
        var protocolPrice:Bool = false
        
        /// 中转机场 ,
        var transferAirport:String = ""
        
        var transferCity:String = ""
        /// 中转时间（分）
        var transferTime:String = ""
        
        override required init() {
            super.init()
        }
        
        required init?(jsonData: JSON) {
            self.amount = NSInteger(jsonData["amount"].numberValue)
            self.cabins = jsonData["cabins"].arrayValue.map{CabinVO(jsonData:$0)!}
            self.cacheId = jsonData["cacheId"].stringValue
            self.contraryPolicy = jsonData["contraryPolicy"].boolValue
            self.direct = jsonData["direct"].boolValue
            self.discount = jsonData["discount"].numberValue
            self.flightInfos = jsonData["flightInfos"].arrayValue.map{FlightVO(jsonData:$0)!}
            self.id = jsonData["id"].stringValue
            self.price = jsonData["price"].numberValue
            self.protocolPrice = jsonData["protocolPrice"].boolValue
            self.transferAirport = jsonData["transferAirport"].stringValue
            self.transferCity = jsonData["transferCity"].stringValue
            self.transferTime = jsonData["transferTime"].stringValue
            for element in flightInfos {
                element.transferTime = transferTime
            }
            
            
            
        }
        func encode(with aCoder: NSCoder) {
            self.mj_encode(aCoder)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init()
            self.mj_decode(aDecoder)
        }
        
        
    }
    class AirlineCompanyVO : NSObject ,ALSwiftyJSONAble,NSCoding{
        ///公司编号 ,
        var code:String = ""
        /// 公司名称
        var name:String = ""
        
        override required init() {
            super.init()
        }
        
        required init?(jsonData: JSON) {
            self.code = jsonData["code"].stringValue
            self.name = jsonData["name"].stringValue
        }
        func encode(with aCoder: NSCoder) {
            self.mj_encode(aCoder)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init()
            self.mj_decode(aDecoder)
        }
        
        
    }
    class CabinVO: NSObject ,ALSwiftyJSONAble,NSCoding{
        
        
        /// 是否被推荐 替换 false 无推荐 true 有推荐
        var hasRecommend:Bool = false
        
        var flightCacheId:String = ""
        ///机票数量 ,
        var amount:NSInteger = 0
        /// 查询结果缓存ID ,
        var cacheId:String = ""
        /// 仓位的类型 括号里的字母 ,
        var code:String = ""
        ///是否违反差旅政策 , true 违背 1。false 符合 0
        var contraryPolicy:Bool = false
        /// 违法政策描述
        var contraryPolicyDesc:String = ""
        /// 折扣 ,
        var discount:NSNumber = 0
        ///退改签规则
        var ei:String = ""
        /// 仓位ID
        var id:String = ""
        /// 价格 ,
        var price:NSNumber = 0
        //是否为协议舱位 ,
        var protocolPrice:Bool = false
        ///是否协议价
        var ifAccountCodePrice:Bool = false
        ///原价
        var orginPrice:NSNumber = 0
        ///  (number, optional): 燃油税 ,
        var fuelTax:NSNumber = 0
        ///仓位
        var shipping:String = ""
        /// 舱位税
        var tax:NSNumber = 0
        
        var childFuelTax:NSNumber = 0
        var childPrice:NSNumber = 0
        var childTax:NSNumber = 0
        
        
        override required init() {
            super.init()
        }
        
        required init?(jsonData: JSON) {
            self.amount = NSInteger(jsonData["amount"].numberValue)
            self.cacheId = jsonData["cacheId"].stringValue
            self.code = jsonData["code"].stringValue
            self.contraryPolicy = jsonData["contraryPolicy"].boolValue
            self.contraryPolicyDesc = jsonData["contraryPolicyDesc"].stringValue
            self.discount = jsonData["discount"].numberValue
            self.ei = jsonData["ei"].stringValue
            self.id = jsonData["id"].stringValue
            self.price = jsonData["price"].numberValue
            self.protocolPrice = jsonData["protocolPrice"].boolValue
            self.shipping = jsonData["shipping"].stringValue
            self.fuelTax = jsonData["fuelTax"].numberValue
            self.tax = jsonData["tax"].numberValue
            self.ifAccountCodePrice = jsonData["ifAccountCodePrice"].boolValue
            self.orginPrice = jsonData["orginPrice"].numberValue
            self.fuelTax = jsonData["fuelTax"].numberValue
            self.tax = jsonData["tax"].numberValue
            self.childFuelTax = jsonData["childFuelTax"].numberValue
            self.childPrice = jsonData["childPrice"].numberValue
            self.childTax = jsonData["childTax"].numberValue
            
        }
        func encode(with aCoder: NSCoder) {
            self.mj_encode(aCoder)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init()
            self.mj_decode(aDecoder)
        }
        
        
    }
    class FlightVO: NSObject ,ALSwiftyJSONAble,NSCoding{
        ///到达机场三字码 ,
        var arriveAirportCode:String = ""
        ///(string, optional): 到达机场名称 ,
        var arriveAirportName :String = ""
        ///到达城市 ,
        var arriveCity:String = ""
        ///  到达时间 ,
        var arriveDate:NSInteger = 0
        ///到达航站楼 ,
        var arriveTerminal:String = ""
        /// 实际运营航班编码 ,
        var carriageCode:String = ""
        /// 实际运营航班公司名称 ,
        var carriageName:String = ""
        /// 实际运营航班编号 ,
        var carriageNo:String = ""
        /// 实际运营航班公司名称简写
        var carriageShortName:String = ""
        
        var craftTypeClassShort:String = ""
        
        var craftTypeName:String = ""
        
        var craftType:String = ""
        ///, optional): 航空公司编码 ,
        var flightCode:String = ""
        /// 航空公司名称 ,
        var flightName:String = ""
        /// 航班编号 ,
        var flightNo:String = ""
        /// 航空公司名称简写
        var flightShortName:String = ""
        /// 飞行时间 ,
        var flightTime:String = ""
        /// 飞行时间 ,
        var flyDays:NSInteger = 0
        /// 餐食 ,
        var mealCode:String = ""
        
        /// 是否为共享航班
        var share:Bool = false
        /// 是否经停 ,
        var stopOver:Bool = false
        /// 经停城市 ,
        var stopOverCity:String = ""
        /// 经停时长（分） ,
        var stopOverTime:String = ""
        /// 起飞机场三字码 ,
        var takeOffAirportCode:String = ""
        /// (string, optional): 起飞机场名称 ,
        var takeOffAirportName:String = ""
        /// 起飞城市
        var takeOffCity:String = ""
        /// 出发时间 ,
        var takeOffDate:NSInteger = 0
        /// 起飞航站楼
        var takeOffTerminal:String = ""
        
        // 下面字段是由外层传递进来的 这只做初始化
        ///是否直达
        var direct:Bool = false
        //是否违反差旅政策
        var contraryPolicy:Bool = false
        
        /// 价格
        var price:NSNumber = 0
        ///中转机场
        var transferAirport:String = ""
        //中转城市
        var transferCity:String = ""
        ///中转时间（分）
        var transferTime:String = ""
        
        
        var departureDateFrom:String = ""
        var departureDateFromTo:String = ""
        var returnDateFrom:String = ""
        var returnDateTo:String = ""
        
        
        override required init() {
            super.init()
        }
        
        required init?(jsonData: JSON) {
            self.arriveAirportCode = jsonData["arriveAirportCode"].stringValue
            self.arriveAirportName = jsonData["arriveAirportName"].stringValue
            self.arriveCity = jsonData["arriveCity"].stringValue
            self.arriveDate = jsonData["arriveDate"].intValue
            self.arriveTerminal = jsonData["arriveTerminal"].stringValue
            self.carriageCode = jsonData["carriageCode"].stringValue
            self.carriageName = jsonData["carriageName"].stringValue
            self.craftTypeName = jsonData["craftTypeName"].stringValue
            self.carriageNo = jsonData["carriageNo"].stringValue
            self.carriageShortName = jsonData["carriageShortName"].stringValue
            self.craftTypeClassShort = jsonData["craftTypeClassShort"].stringValue
            self.craftType = jsonData["craftType"].stringValue
            self.flightCode = jsonData["flightCode"].stringValue
            self.flightName = jsonData["flightName"].stringValue
            self.flightNo = jsonData["flightNo"].stringValue
            self.flightShortName = jsonData["flightShortName"].stringValue
            self.flightTime = jsonData["flightTime"].stringValue
            self.flyDays = jsonData["flyDays"].intValue
            self.mealCode = jsonData["mealCode"].stringValue
            self.share = jsonData["share"].boolValue
            self.stopOver = jsonData["stopOver"].boolValue
            self.stopOverCity = jsonData["stopOverCity"].stringValue
            self.stopOverTime = jsonData["stopOverTime"].stringValue
            self.takeOffAirportCode = jsonData["takeOffAirportCode"].stringValue
            self.takeOffAirportName = jsonData["takeOffAirportName"].stringValue
            self.takeOffCity = jsonData["takeOffCity"].stringValue
            self.takeOffDate = jsonData["takeOffDate"].intValue
            self.takeOffTerminal = jsonData["takeOffTerminal"].stringValue
        }
        func encode(with aCoder: NSCoder) {
            self.mj_encode(aCoder)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init()
            self.mj_decode(aDecoder)
        }
        
        
    }
}

extension Array where Element == PCommonFlightSVSearchModel.AirlineCompanyVO {
    
    func filterCompanyCode(_ companyArr:[String]) -> [Element]{
        //return self.filter{companyArr.contains($0.legList.first?.marketAirlineShort ?? "unknow")}
        return self.filter{ companyArr.contains($0.code )}
    }
    
    
}


extension Array where Element == PCommonFlightSVSearchModel.AirfareVO {
    /// 航班排序
    ///
    /// - Parameter by: 排序规则
    /// - Returns: 排序后的结果
    func sorted(_ by:FlightSort) -> [Element] {
        // 计算起飞时间
        switch by {
        case .priceAsc:
            return self.sorted{$0.price.intValue < $1.price.intValue}
        case .priceDesc:
            return self.sorted{$0.price.intValue > $1.price.intValue}
        case .timeAsc:
            return self.sorted{($0.flightInfos.first?.takeOffDate ?? 0) < ($1.flightInfos.first?.takeOffDate ?? 0)}
        case .timeDesc:
            return self.sorted{($0.flightInfos.first?.takeOffDate ?? 0) > ($1.flightInfos.first?.takeOffDate ?? 0)}
        case .defaultSort:
            return self.sorted{$0.price.intValue < $1.price.intValue}
        }
    }
    
    /// 根据航空公司编码过滤航班信息
    ///
    /// - Parameter companyArr: 需要过滤的航空公司code
    /// - Returns: 过滤后的结果
    func filterCompany(_ companyArr:[String]) -> [Element]{
        //return self.filter{companyArr.contains($0.legList.first?.marketAirlineShort ?? "unknow")}
        return self.filter{ companyArr.contains($0.flightInfos.first?.flightShortName ?? "unknow")}
    }
    
    func filterFlightCode(_ companyArr:[String]) -> [Element]{
        //return self.filter{companyArr.contains($0.legList.first?.marketAirlineShort ?? "unknow")}
        return self.filter{ companyArr.contains($0.flightInfos.first?.flightCode ?? "unknow")}
    }
    
    
    
    
    
    
    /// 根据仓位过滤航班信息  //这个方法 有点问题 下面方法 暂时替换
    ///
    /// - Parameter cabinType: 仓位类型
    /// - Returns: 过滤后的结果
    func filterCabin(_ cabinType:[String]) -> [Element]{
        printDebugLog(message: self.count)
        return self.map{flightItem in
            let flight = flightItem
            printDebugLog(message: flight.cabins.count)
            flight.cabins = flightItem.cabins.filter{
                cabinType.contains($0.shipping)
            }
            return flight
            }.filter{
                $0.cabins.count > 0
                
        }
    }
    
    func newFilterCabin(_ cabinType:String) -> [Element]{
        
        return self.map({ (flightItem) -> Element in
            
            let flight = flightItem
            flight.cabins = flightItem.cabins.filter{$0.shipping.contains(cabinType)}
            return flight
        }).filter{$0.cabins.count > 0}
    }
    
    
    func filterCabinn(_ cabinType:[String]) -> [Element]{
        return self.map{flightItem in
            let flight = flightItem
            flight.cabins = flightItem.cabins.filter{cabinType.contains($0.shipping)}
            return flight
            }.filter{$0.cabins.count > 0}
    }
    ///根据是否直达编码过滤航班信息
    ///
    /// - Parameter isDirect: 是否直达
    /// - Returns: 过滤后结果
    func filterDirect(_ isDirect:Bool) -> [Element]{
        return self.filter{ $0.direct == isDirect}
    }
    
    /// 限时航班起飞时间的最大值(早于该时间的都符合要求)
    ///
    /// - Parameter time: 最晚时间
    /// - Returns: 过滤后结果 //item.takeOffDateTime.date(format: .custom("HH:mm"))!
    func maxTimeLimit(_ time:Date) -> [Element]{
        return self.reduce([]){all,item in
            guard ((item.flightInfos.first?.takeOffDate ?? 0) / 1000) < NSInteger(time.timeIntervalSince1970) else{
                return all
            }
            return all + [item]
        }
    }
    
    /// 限时航班起飞时间的最小值(晚于该时间的都符合要求)
    ///
    /// - Parameter time: 最早时间
    /// - Returns: 过滤后结果
    func minTimeLimit(_ time:Date) -> [Element]{
        return self.reduce([]){all,item in
            guard ((item.flightInfos.first?.takeOffDate  ?? 0) / 1000) > NSInteger(time.timeIntervalSince1970) else {
                return all
            }
            return all + [item]
        }
    }
    
    /// 计算航班所有仓位
    ///
    /// - Returns: 此次查询结果的所有仓位
    func getAllCabin() -> [String] {
        return self.reduce([]){all,airfare in all + airfare.cabins.map{$0.shipping} }.distinct()
    }
    
    /// 计算搜索结果中的所有航空公司code
    ///
    /// - Returns: 此次查询结果的所有航空公司信息
    func getAllCompanyCode() -> [(code:String,name:String)]{
        return self.reduce([]){all,flight in
            
            guard let code = flight.flightInfos.first?.flightCode, let name = flight.flightInfos.first?.flightShortName else {
                return all
            }
            return all + [(code,name)]
            }.distinct{$0.code == $1.code}
    }
    
    /// 获取此次查询的最低价格
    ///
    /// - Returns: 最低价
    func getLowestPrice() -> Int{
        return self.min{$0.price.intValue < $1.price.intValue}?.price.intValue ?? 0
    }
}
