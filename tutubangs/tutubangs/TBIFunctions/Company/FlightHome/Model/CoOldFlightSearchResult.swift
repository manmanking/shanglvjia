//
//  CoOldFlightSearchResult.swift
//  shop
//
//  Created by akrio on 2017/5/19.
//  Copyright © 2017年 zhangwangwang. All rights reserved.
//

import Foundation
import Moya_SwiftyJSONMapper
import SwiftyJSON
import SwiftDate
/// 企业新版航班查询结果
struct CoOldFlightSearchResult:ALSwiftyJSONAble {
    /// 起飞城市名
    let takeOffCity:String
    /// 到达城市名
    let arriveCity:String
    /// 去程起飞日期
    let departTakeoffDate:DateInRegion
    /// 航班信息
    let flightList:[FlightItem]
    
    /// 计算航班所有仓位
    var allCabin:[String] {
        return flightList.getAllCabin()
    }
    
    /// 计算搜索结果中的所有航空公司
    var allCompanyCode:[(code:String,name:String)] {
        return flightList.getAllCompanyCode()
    }
    
    /// 获取此次查询的最低价格
    var lowestPrice:Int {
        return flightList.getLowestPrice()
    }
    
    init(jsonData result:JSON){
        self.takeOffCity = result["takeOffAirportName"].stringValue
        self.arriveCity = result["arriveAirportName"].stringValue
        self.departTakeoffDate = result["takeOffDate"].dateFormat(.unix)
        self.flightList = result["airfares"].arrayValue.map{ FlightItem(jsonData: $0) }
    }
    /// 企业新版航班单条信息
    struct FlightItem:ALSwiftyJSONAble {
        /// 是否代码共享航班
        let codeShare:Bool
        /// 是否直达航班
        let direct:Bool
        /// 是否经停航班
        let stop:Bool
        /// 出发到达是否同一天
        let sameDay:Bool
        /// 航段信息
        let legList:[LegItem]
        /// 仓位信息
        var cabinList:[CabinItem]
        
        /// 计算属性 获取第一条航段的起飞时间
        var takeOffDateTime:String {
            guard let firstLeg = self.legList.first else {
                return ""
            }
            return firstLeg.takeOffTime
        }
        /// 计算属性 获取第一条航段的起飞机场
        var takeOffStnTxt:String {
            guard let firstLeg = self.legList.first else {
                return ""
            }
            return firstLeg.takeOffStnTxt
        }
        /// 计算属性 获取第一条航段的起飞航站楼
        var takeOffTerminal:String {
            guard let firstLeg = self.legList.first else {
                return ""
            }
            return firstLeg.takeOffTerminal
        }
        /// 计算属性 获取最后航段的到达时间
        var arriveDateTime:String {
            guard let lastLeg = self.legList.last else {
                return ""
            }
            return lastLeg.arriveTime
        }
        /// 计算属性 获取最后航段的到达机场
        var arriveStnTxt:String {
            guard let lastLeg = self.legList.last else {
                return ""
            }
            return lastLeg.arriveStnTxt
        }
        /// 计算属性 获取第最后航段的到达航站楼
        var arriveTerminal:String {
            guard let lastLeg = self.legList.last else {
                return ""
            }
            return lastLeg.arriveTerminal
        }
        /// 计算属性 获取航空公司2字码
        var flightCode:String {
            guard let firstLeg = self.legList.first else {
                return ""
            }
            return firstLeg.marketAirlineCode
        }
        
        /// 计算属性 获取航空公司名称
        var flightName:String {
            guard let firstLeg = self.legList.first else {
                return ""
            }
            return firstLeg.marketFlightName
        }
        
        /// 计算属性 获取航班编号
        var flightNo:String {
            guard let firstLeg = self.legList.first else {
                return ""
            }
            return firstLeg.marketFlightNo
        }
        
        /// 计算属性 是否符合差旅政策
        var contraryPolicy:Bool {
            return cabinList.contains{ $0.contraryPolicy }
        }
        
        /// 该段航班最低价
        var price:Int { return cabinList.sorted{$0.price < $1.price}.first?.price ?? 999999 }
        
        init(jsonData:JSON){
            self.codeShare = jsonData["flightInfos"].arrayValue.first?["share"].boolValue ?? false
            self.direct = jsonData["direct"].boolValue
            self.stop = jsonData["stopOver"].boolValue
            // =====计算是否跨天======
            let takeOffDate = jsonData["flightInfos"].arrayValue.first!["takeOffDate"].dateFormat(.unix) ?? DateInRegion()
            let arriveDate = jsonData["flightInfos"].arrayValue.last!["arriveDate"].dateFormat(.unix) ?? DateInRegion()
            let days = (arriveDate.timeIntervalSinceReferenceDate - takeOffDate.timeIntervalSinceReferenceDate).in(.day) ?? 0
            self.sameDay = days > 0
            
            self.legList = jsonData["flightInfos"].arrayValue.map{LegItem(jsonData: $0 )}
            self.cabinList = jsonData["cabins"].arrayValue.map{CabinItem(jsonData: $0 )}
        }
        /// 航班仓位信息
        struct CabinItem : ALSwiftyJSONAble{
            /// 唯一标识
            let id:String
            /// 价格
            let price:Int
            /// 税费
            let tax:Int
            /// 舱位类型
            let cabinTypeText:String
            /// 舱位折扣
            let discount:Double
            /// 剩余票数 大于9张为 -1
            let num:Int
            /// 退改签规则
            let ei:String
            /// 是否违反差旅政策
            let contraryPolicy:Bool
            /// 违反差旅政策描述
            let contraryPolicyDesc:String
            init(jsonData:JSON){
                self.id = jsonData["id"].stringValue
                self.price = jsonData["price"].intValue
                self.tax = jsonData["tax"].intValue
                self.ei = jsonData["ei"].stringValue.replacingOccurrences(of: "<br>", with: "\r\n")
                self.cabinTypeText = jsonData["shipping"].stringValue
                self.discount = jsonData["discount"].doubleValue
                self.num = jsonData["amount"].intValue
                self.contraryPolicy = jsonData["contraryPolicy"].boolValue
                self.contraryPolicyDesc = jsonData["contraryPolicyDesc"].stringValue
            }
        }
        /// 航段信息
        struct LegItem:ALSwiftyJSONAble{
            /// 到达日期
            let arriveDate:String
            /// 到达航站楼
            let arriveTerminal:String
            /// 到达时间
            let arriveTime:String
            /// 到达城市名字
            let arriveCity:String
            /// 到达机场文字
            let arriveStnTxt:String
            /// 起飞日期
            let takeOffDate:String
            /// 起飞城市
            let takeOffCity:String
            /// 起飞机场文字
            let takeOffStnTxt:String
            /// 起飞机场航站楼
            let takeOffTerminal:String
            /// 起飞机场时间HHmm
            let takeOffTime:String
            /// 运营航空公司代码
            let marketAirlineCode:String
            /// 运营航班号
            let marketFlightNo:String
            /// 运营飞机名字
            let marketFlightName:String
            /// 承运航空公司代码
            let carriageAirlineCode:String
            /// 承运航班号
            let carriageFlightNo:String
            /// 承运航空公司名字
            let carriageFlightName:String
            init(jsonData:JSON){
                let arriveDateTime = jsonData["arriveDate"].dateFormat(.unix)
                self.arriveDate = arriveDateTime.string(custom: "yyyy-MM-dd")
                self.arriveTerminal = jsonData["arriveTerminal"].stringValue
                self.arriveTime = arriveDateTime.string(custom: "HH:mm")
                self.arriveCity = jsonData["arriveCity"].stringValue
                self.arriveStnTxt = jsonData["arriveAirportName"].stringValue
                
                let takeOffDateTime = jsonData["takeOffDate"].dateFormat(.unix)
                self.takeOffDate = takeOffDateTime.string(custom: "yyyy-MM-dd")
                self.takeOffTerminal = jsonData["takeOffTerminal"].stringValue
                self.takeOffCity = jsonData["takeOffCity"].stringValue
                self.takeOffTime = takeOffDateTime.string(custom: "HH:mm")
                self.takeOffStnTxt = jsonData["takeOffAirportName"].stringValue
                
                self.marketAirlineCode = jsonData["flightCode"].stringValue
                self.marketFlightNo = jsonData["flightNo"].stringValue
                self.marketFlightName = jsonData["flightName"].stringValue
                
                self.carriageAirlineCode = jsonData["carriageCode"].stringValue
                self.carriageFlightNo = jsonData["carriageNo"].stringValue
                self.carriageFlightName = jsonData["carriageName"].stringValue
            }
        }
    }
}

extension Array where Element == CoOldFlightSearchResult.FlightItem {
    /// 航班排序
    ///
    /// - Parameter by: 排序规则
    /// - Returns: 排序后的结果
    func sorted(_ by:FlightSort) -> [Element] {
        // 计算起飞时间
        switch by {
        case .priceAsc:
            return self.sorted{$0.price < $1.price}
        case .priceDesc:
            return self.sorted{$0.price > $1.price}
        case .timeAsc:
            return self.sorted{$0.takeOffDateTime < $1.takeOffDateTime}
        case .timeDesc:
            return self.sorted{$0.takeOffDateTime > $1.takeOffDateTime}
        case .defaultSort:
            break
        }
        return [Element]()
    }
    
    /// 根据航空公司编码过滤航班信息
    ///
    /// - Parameter companyArr: 需要过滤的航空公司code
    /// - Returns: 过滤后的结果
    func filterCompany(_ companyArr:[String]) -> [Element]{
        return self.filter{companyArr.contains($0.legList.first?.marketAirlineCode ?? "unknow")}
    }
    /// 根据仓位过滤航班信息
    ///
    /// - Parameter cabinType: 仓位类型
    /// - Returns: 过滤后的结果
    func filterCabin(_ cabinType:[String]) -> [Element]{
        return self.map{flightItem in
            var flight = flightItem
            flight.cabinList = flightItem.cabinList.filter{cabinType.contains($0.cabinTypeText)}
            return flight
            }.filter{$0.cabinList.count > 0}
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
    /// - Returns: 过滤后结果
    func maxTimeLimit(_ time:Date) -> [Element]{
        return self.reduce([]){all,item in
            guard item.takeOffDateTime.date(format: .custom("HH:mm"))! < time.inRegion() else{
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
            guard item.takeOffDateTime.date(format: .custom("HH:mm"))! > time.inRegion() else{
                return all
            }
            return all + [item]
        }
    }
    
    /// 计算航班所有仓位
    ///
    /// - Returns: 此次查询结果的所有仓位
    func getAllCabin() -> [String] {
        return self.reduce([]){all,flight in all + flight.cabinList.map{$0.cabinTypeText} }.distinct()
    }
    
    /// 计算搜索结果中的所有航空公司code
    ///
    /// - Returns: 此次查询结果的所有航空公司信息
    func getAllCompanyCode() -> [(code:String,name:String)]{
        return self.reduce([]){all,flight in
            guard let code = flight.legList.first?.marketAirlineCode,let name = flight.legList.first?.marketFlightName else {
                return all
            }
            return all + [(code,name)]
            }.distinct{$0.code == $1.code}
    }
    
    /// 获取此次查询的最低价格
    ///
    /// - Returns: 最低价
    func getLowestPrice() -> Int{
        return self.min{$0.price < $1.price}?.price ?? 0
    }
}
