//
//  FlightListItem.swift
//  shop
//
//  Created by akrio on 2017/4/24.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import SwiftyJSON
import Moya_SwiftyJSONMapper
import SwiftDate

/// 航班列表实体
struct FlightListItem:ALSwiftyJSONAble {
    /// 是否代码共享航班
    let codeShare:Bool
    /// 是否经停航班
    let stopOver:Bool
    /// 是否直达航班
    let direct:Bool
    /// 出发到达是否同一天
    let sameDay:Bool
    /// 航段信息
    let legList:[FlightLegListItem]
    /// 仓位信息
    var cabinList:[CabinListItem]
    var takeOffDateTime:DateInRegion {
        let firstLeg = self.legList.first!
        guard let time = firstLeg.takeOffTime.date(format: .custom("HH:mm")) else {
            return DateInRegion()
        }
        return time
    }
    /// 该段航班最低价
    var price:Int { return cabinList.sorted{$0.price < $1.price}.first?.price ?? 999999 }
    
    init(jsonData:JSON){
        self.codeShare = jsonData["codeShare"].boolValue
        self.direct = jsonData["direct"].boolValue
        self.stopOver = jsonData["stopover"].boolValue
        self.sameDay = jsonData["sameDay"].boolValue
        self.legList = jsonData["legList"].arrayValue.map{FlightLegListItem(jsonData: $0 )}
        self.cabinList = jsonData["cabinList"].arrayValue.map{CabinListItem(jsonData: $0 )}
    }
}
/// 航班排序
///
/// - timeAsc: 时间升序
/// - timeDesc: 时间降序
/// - priceAsc: 价格升序
/// - priceDesc: 价格降序
enum FlightSort {
    case timeAsc
    case timeDesc
    case priceAsc
    case priceDesc
    case defaultSort
}
extension Array where Element == FlightListItem {
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
            return self.sorted{$0.price < $1.price}
        }
    }
    
    /// 根据航空公司编码过滤航班信息
    ///
    /// - Parameter companyArr: 需要过滤的航空公司code
    /// - Returns: 过滤后的结果
    func filterCompany(_ companyArr:[String]) -> [Element]{
        return self.filter{companyArr.contains($0.legList.first?.marketAirlineShort ?? "unknow")}
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
            guard item.takeOffDateTime < time.inRegion() else{
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
            guard item.takeOffDateTime > time.inRegion() else{
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
            guard let code = flight.legList.first?.marketAirlineCode,let name = flight.legList.first?.marketAirlineShort else {
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
