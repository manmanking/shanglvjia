//
//  TrainListItem.swift
//  shop
//
//  Created by TBI on 2017/12/25.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import SwiftyJSON
import Moya_SwiftyJSONMapper
import SwiftDate

//二等、一等、商务、特等、硬座、硬卧、软卧、无座、软座、高级软卧
enum SeatTrain:String {
    case edzSeat = "二等座"
    case ydzSeat = "一等座"
    case swzSeat = "商务座"
    case tdzSeat = "特等座"
    case yzSeat = "硬座"
    case ywSeat  = "硬卧"
    case rwSeat  = "软卧"
    case wzSeat  = "无座"
    case rzSeat  = "软座"
    case gjrwSeat  = "高级软卧"
    case defaultSeat = "none"
}

struct CoTrainListItem: ALSwiftyJSONAble {
    
    var  status:String
    
    var  parIds:String
    
    var trainAvailInfo:[CoTrainAvailInfo]
    
    init(jsonData:JSON){
        self.status = jsonData["status"].stringValue
        self.parIds = jsonData["parIds"].stringValue
        self.trainAvailInfo = jsonData["trainAvailInfos"].arrayValue.map{CoTrainAvailInfo(jsonData: $0 )}
    }
}


struct CoTrainAvailInfo: ALSwiftyJSONAble{
    
    /// 出发站名称
    var  fromStationName:String
    /// 出发站编码
    var  fromStationCode:String
    /// 始发站名称
    var  startStationName:String
    /// 到达站名称
    var  toStationName:String
    /// 到达站编码
    var  toStationCode:String
    /// 终点站名称
    var  endStationName:String
    /// 商务座余票数量
    var swzNum:String
    /// 商务座票价
    var swzPrice:String
    /// 商务座是否违反差标
    var swzPolicy:Bool
    /// 特等座余票数量
    var tdzNum:String
    /// 特等座票价
    var tdzPrice:String
    /// 特等座是否违反
    var tdzPolicy:Bool
    /// 一等座余票数量
    var ydzNum:String
    /// 一等座票价
    var ydzPrice:String
    /// 一等座是否违反差标 （1：是，0：否）
    var ydzPolicy:Bool
    /// 二等座余票数量
    var edzNum:String
    /// 二等座票价
    var edzPrice:String
    /// 二等座是否违反差标 （1：是，0：否）
    var edzPolicy:Bool
    /// 软座余票数量
    var rzNum:String
    /// 软座票价
    var rzPrice:String
    /// 软座是否违反
    var rzPolicy:Bool
    /// 硬座余票数量
    var yzNum:String
    /// 硬座票价
    var yzPrice:String
    /// 硬座是否违反
    var yzPolicy:Bool
    /// 无座余票数量
    var wzNum:String
    /// 无座票价
    var wzPrice:String
    /// 无座票价
    var wzPolicy:Bool
    /// 高级软卧余票数量
    var gjrwNum:String
    /// 高级软卧票价
    var gjrwPrice:String
    /// 高级软卧是否违反
    var gjrwPolicy:Bool
    /// 软卧余票数量
    var rwNum:String
    /// 软卧票价
    var rwPrice:String
    /// 软卧是否违反
    var rwPolicy:Bool
    /// 硬卧余票数量
    var ywNum:String
    /// 硬卧票价
    var ywPrice:String
    /// 硬卧是否违反
    var ywPolicy:Bool
    /// 车次
    var trainCode:String
    /// 列车号
    var trainNo:String
    /// 列车类型
    var trainType:String
    /// 运行时间
    var runTime:String
    /// 出发时刻
    var startTime:String
    /// 到达时刻
    var arriveTime:String
    /// 列车从始发站出发的日期
    var trainStartDate:String
    /// 列车从出发站到达目的站的运行天数 0:当日到达1,: 次日到达,2:三日到达,3:四日到达,依此类推
    var arriveDay:String
    /// 是否可凭二代身份证直接进出站 1:是，0：否
    var accessByIdCard:String
    /// 车票开售时间
    var saleDateTime:String
    /// 当前是否可以接受预定
    var canBuyNow:String
    /// 出发站是否是始发站 \"0\" : 否，”1“ 是
    var isStart:Bool
    /// 到达站是否是终点站 \"0\" : 否，”1“ 是")
    var isEnd:Bool
    
    init(jsonData:JSON){
        self.fromStationName = jsonData["fromStationName"].stringValue
        self.fromStationCode = jsonData["fromStationCode"].stringValue
        self.startStationName = jsonData["startStationName"].stringValue
        self.toStationName = jsonData["toStationName"].stringValue
        self.toStationCode = jsonData["toStationCode"].stringValue
        self.endStationName = jsonData["endStationName"].stringValue
        self.swzNum = jsonData["swzNum"].stringValue
        self.swzPrice = jsonData["swzPrice"].stringValue
        self.tdzNum = jsonData["tdzNum"].stringValue
        self.tdzPrice = jsonData["tdzPrice"].stringValue
        self.ydzNum = jsonData["ydzNum"].stringValue
        self.ydzPrice = jsonData["ydzPrice"].stringValue
        self.edzNum = jsonData["edzNum"].stringValue
        self.edzPrice = jsonData["edzPrice"].stringValue
        self.rzNum = jsonData["rzNum"].stringValue
        self.rzPrice = jsonData["rzPrice"].stringValue
        self.yzNum = jsonData["yzNum"].stringValue
        self.yzPrice = jsonData["yzPrice"].stringValue
        self.wzNum = jsonData["wzNum"].stringValue
        self.wzPrice = jsonData["wzPrice"].stringValue
        self.gjrwNum = jsonData["gjrwNum"].stringValue
        self.gjrwPrice = jsonData["gjrwPrice"].stringValue
        self.rwNum = jsonData["rwNum"].stringValue
        self.rwPrice = jsonData["rwPrice"].stringValue
        self.ywNum = jsonData["ywNum"].stringValue
        self.ywPrice = jsonData["ywPrice"].stringValue
        self.trainCode = jsonData["trainCode"].stringValue
        self.trainNo = jsonData["trainNo"].stringValue
        self.trainType = jsonData["trainType"].stringValue
        self.runTime = jsonData["runTime"].stringValue
        self.startTime = jsonData["startTime"].stringValue
        self.arriveTime = jsonData["arriveTime"].stringValue
        self.trainStartDate = jsonData["trainStartDate"].stringValue
        self.arriveDay = jsonData["arriveDay"].stringValue
        self.accessByIdCard = jsonData["accessByIdCard"].stringValue
        self.saleDateTime = jsonData["saleDateTime"].stringValue
        self.canBuyNow = jsonData["canBuyNow"].stringValue
        self.isStart = jsonData["isStart"].stringValue == "1" ? true : false
        self.isEnd = jsonData["isEnd"].stringValue  == "1" ? true : false
        
        self.edzPolicy = jsonData["edzPolicy"].stringValue  == "1" ? true : false
        self.gjrwPolicy = jsonData["gjrwPolicy"].stringValue  == "1" ? true : false
        self.rwPolicy = jsonData["rwPolicy"].stringValue  == "1" ? true : false
        self.rzPolicy = jsonData["rzPolicy"].stringValue  == "1" ? true : false
        self.swzPolicy = jsonData["swzPolicy"].stringValue  == "1" ? true : false
        self.tdzPolicy = jsonData["tdzPolicy"].stringValue  == "1" ? true : false
        self.wzPolicy = jsonData["wzPolicy"].stringValue  == "1" ? true : false
        self.ydzPolicy = jsonData["ydzPolicy"].stringValue  == "1" ? true : false
        self.ywPolicy = jsonData["ywPolicy"].stringValue  == "1" ? true : false
        self.yzPolicy = jsonData["yzPolicy"].stringValue  == "1" ? true : false
    }
    
}



/// 火车票排序
///
/// - startTimeAsc: 出发升序
/// - startTimeDesc: 出发倒序
/// - endTimeAsc: 到达升序
/// - endTimeDesc: 到达倒序
/// - runTimeAsc: 用时升序
/// - runTimeDesc: 用时倒叙
/// - defaultSort: 默认
enum TrainSort {
    case startTimeAsc
    case startTimeDesc
    case endTimeAsc
    case endTimeDesc
    case runTimeAsc
    case runTimeDesc
    case defaultSort
}
extension Array where Element == CoTrainAvailInfo {
    
    ///火车票排序
    ///
    /// - Parameter by: 排序规则
    /// - Returns: 排序后的结果
    func sorted(_ by:TrainSort) -> [Element] {
        // 计算起飞时间
        switch by {
        case .startTimeAsc:
            return self.sorted{$0.startTime < $1.startTime}
        case .startTimeDesc:
            return self.sorted{$0.startTime > $1.startTime}
        case .endTimeAsc:
            return self.sorted(by: { (s1, s2) -> Bool in
                if s1.arriveDay == s2.arriveDay {
                   return s1.arriveTime < s2.arriveTime
                }else {
                    return s1.arriveDay < s2.arriveDay
                }
            })
            //return self.sorted{$0.arriveTime < $1.arriveTime  }
        case .endTimeDesc:
            return self.sorted(by: { (s1, s2) -> Bool in
                if s1.arriveDay == s2.arriveDay {
                    return s1.arriveTime > s2.arriveTime
                }else {
                    return s1.arriveDay > s2.arriveDay
                }
            })
            //return self.sorted{$0.arriveTime > $1.arriveTime  }
        case .runTimeAsc:
            return self.sorted{$0.runTime < $1.runTime}
        case .runTimeDesc:
            return self.sorted{$0.runTime > $1.runTime}
        case .defaultSort:
            return self.sorted{$0.startTime < $1.startTime}
        }
    }
    
    
    /// 限时列车开车时间的最大值(早于该时间的都符合要求)
    ///
    /// - Parameter time: 最晚时间
    /// - Returns: 过滤后结果
    func maxTimeLimit(_ time:String) -> [Element]{
        return self.reduce([]){all,item in
            guard item.startTime < time else{
                return all
            }
            return all + [item]
        }
    }
    
    /// 限时列车开车时间的最小值(晚于该时间的都符合要求)
    ///
    /// - Parameter time: 最早时间
    /// - Returns: 过滤后结果
    func minTimeLimit(_ time:String) -> [Element]{
        return self.reduce([]){all,item in
            guard item.startTime > time else{
                return all
            }
            return all + [item]
        }
    }
    
    /// 过滤后列车类型
    ///
    /// - Parameter : 列车类型
    /// - Returns: 过滤列车类型后列表
    func filterTrainType(_ trainTypeArr:[String]) -> [Element]{
        return self.filter{trainTypeArr.contains($0.trainType)}
    }
    
    /// 过滤后出发站到达站
    ///
    /// - Parameter : 出发站到达站
    /// - Returns: 过滤列车类型后列表
    func filterStation(_ stationArr:[String]) -> [Element]{
        return self.filter{stationArr.contains($0.fromStationName) || stationArr.contains($0.toStationName)}
    }
    
    /// 计算搜索结果中的所有车站
    ///
    /// - Returns: 此次搜索结果车站
    func getAllRailwayStation() -> [String]{
        return self.reduce([]){all,train in
            return all + [train.fromStationName]
            }.distinct() +  self.reduce([]){all,train in
                return all + [train.toStationName]
            }.distinct()
    }
    
    /// 过滤是否始发
    ///
    /// - Returns:
    func filterIsStart(isStart:Bool) -> [Element]{
       return self.filter{$0.isStart == isStart}
    }
    
}
