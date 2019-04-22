//
//  QueryTrainResponse.swift
//  shanglvjia
//
//  Created by manman on 2018/4/10.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON

class QueryTrainResponse: NSObject,ALSwiftyJSONAble{

    var parIds:String = ""
    var status:String = ""
    var trainAvailInfos:[TrainAvailInfo] = Array()
    
    override init() {
        
    }
    
    required init?(jsonData: JSON) {
        self.parIds = jsonData["parIds"].stringValue
        self.status = jsonData["status"].stringValue
        self.trainAvailInfos = jsonData["trainAvailInfos"].arrayValue.map{TrainAvailInfo(jsonData:$0)!}
    }
    
    
    
    class TrainAvailInfo: NSObject,ALSwiftyJSONAble {
        
        var selectedTrains: SeatTrain = SeatTrain.defaultSeat
        ///背差标（1：是违背 ，0 符合
        var selectedTrainsPolicy:String = "0"
    
        ///  (string, optional): 是否可凭二代身份证直接进出站 1:是，0：否 ,
        var accessByIdCard:String = ""
        
        ///  (integer, optional): 到达时间 时间格式 ,
        var arriveDateTime:NSInteger = 0
        
        ///  (string, optional): 列车从出发站到达目的站的运行天数 0:当日到达1,: 次日到达,2:三日到达,3:四日到达,依此类推 ,
        var arriveDay:String = ""
        
        ///  (string, optional): 到达时刻 ,
        var arriveTime:String = ""
        
        ///  (string, optional): 当前是否可以接受预定 ,
        var canBuyNow:String = ""
        
        ///  (string, optional): 二等座余票数量 ,
        var edzNum:String = ""
        
        ///  (string, optional): 二等座是否违背差标（1：是，0：否） ,
        var edzPolicy:String = ""
        
        ///  (string, optional): 二等座票价 ,
        var edzPrice:String = ""
        
        ///  (string, optional): 终点站名称 ,
        var endStationName:String = ""
        
        ///  (string, optional): 出发站编码 ,
        var fromStationCode:String = ""
        
        ///  (string, optional): 出发站名称 ,
        var fromStationName:String = ""
        
        ///  (string, optional): 高级软卧余票数量 ,
        var gjrwNum:String = ""
        
        ///  (string, optional): 高级软卧是否违背差标（1：是，0：否） ,
        var gjrwPolicy:String = ""
        
        ///  (string, optional): 高级软卧票价 ,
        var gjrwPrice:String = ""
        
        ///  (string, optional): 到达站是否是终点站 "0" : 否，”1“ 是 ,
        var isEnd:String = ""
        
        ///  (string, optional): 出发站是否是始发站 "0" : 否，”1“ 是 ,
        var isStart:String = ""
        
        ///  (string, optional): 运行时间 ,
        var runTime:String = ""
        
        ///  (string, optional): 软卧余票数量 ,
        var rwNum:String = ""
        
        ///  (string, optional): 软卧是否违背差标（1：是，0：否） ,
        var rwPolicy:String = ""
        
        ///  (string, optional): 软卧票价 ,
        var rwPrice:String = ""
        
        ///  (string, optional): 软座余票数量 ,
        var rzNum:String = ""
        
        ///  (string, optional): 软座是否违背差标（1：是，0：否） ,
        var rzPolicy:String = ""
        
        ///  (string, optional): 软座票价 ,
        var rzPrice:String = ""
        
        ///  (string, optional): 车票开售时间 ,
        var saleDateTime:String = ""
        
        ///  (string, optional): 始发站名称 ,
        var startStationName:String = ""
        
        ///  (string, optional): 出发时刻 ,
        var startTime:String = ""
        
        ///  (string, optional): 商务座余票数量 ,
        var swzNum:String = ""
        
        ///  (string, optional): 商务座是否违背差标（1：是，0：否） ,
        var swzPolicy:String = ""
        
        ///  (string, optional): 商务座票价 ,
        var swzPrice:String = ""
        
        ///  (string, optional): 特等座余票数量 ,
        var tdzNum:String = ""
        
        ///  (string, optional): 特等座是否违背差标（1：是，0：否） ,
        var tdzPolicy:String = ""
        
        ///  (string, optional): 特等座票价 ,
        var tdzPrice:String = ""
        
        ///  (string, optional): 到达站编码 ,
        var toStationCode:String = ""
        
        ///  (string, optional): 到达站名称 ,
        var toStationName:String = ""
        
        ///  (string, optional): 车次 ,
        var trainCode:String = ""
        
        ///  (string, optional): 列车号 ,
        var trainNo:String = ""
        
        ///  (string, optional): 列车从始发站出发的日期 ,
        var trainStartDate:String = ""
        
        ///  (string, optional):  列车类型 ,
        var trainType:String = ""
        
        ///  (string, optional): 无座余票数量 ,
        var wzNum:String = ""
        
        ///  (string, optional): 无座是否违背差标（1：是，0：否） ,
        var wzPolicy:String = ""
        
        ///  (string, optional): 无座票价 ,
        var wzPrice:String = ""
        
        ///  (string, optional): 一等座余票数量 ,
        var ydzNum:String = ""
        
        ///  (string, optional): 一等座是否违背差标（1：是，0：否） ,
        var ydzPolicy:String = ""
        
        ///  (string, optional): 一等座票价 ,
        var ydzPrice:String = ""
        
        ///  (string, optional): 硬卧余票数量 ,
        var ywNum:String = ""
        
        ///  (string, optional): 硬卧是否违背差标（1：是，0：否） ,
        var ywPolicy:String = ""
        
        ///  (string, optional): 硬卧票价 ,
        var ywPrice:String = ""
        
        ///  (string, optional): 硬座余票数量 ,
        var yzNum:String = ""
        
        ///  (string, optional): 硬座是否违背差标（1：是，0：否） ,
        var yzPolicy:String = ""
        
        ///  (string, optional): 硬座票价
        var yzPrice:String = ""
        
        override init() {
            
        }
        required init?(jsonData: JSON) {
            self.accessByIdCard = jsonData["accessByIdCard"].stringValue
            self.arriveDateTime = jsonData["arriveDateTime"].intValue
            self.arriveDay = jsonData["arriveDay"].stringValue
            self.arriveTime = jsonData["arriveTime"].stringValue
            self.canBuyNow = jsonData["canBuyNow"].stringValue
            self.edzNum = jsonData["edzNum"].stringValue
            self.edzPolicy = jsonData["edzPolicy"].stringValue
            self.edzPrice = jsonData["edzPrice"].stringValue
            self.endStationName = jsonData["endStationName"].stringValue
            self.fromStationCode = jsonData["fromStationCode"].stringValue
            self.fromStationName = jsonData["fromStationName"].stringValue
            self.gjrwNum = jsonData["gjrwNum"].stringValue
            self.gjrwPolicy = jsonData["gjrwPolicy"].stringValue
            self.gjrwPrice = jsonData["gjrwPrice"].stringValue
            self.isEnd = jsonData["isEnd"].stringValue
            self.isStart = jsonData["isStart"].stringValue
            self.runTime = jsonData["runTime"].stringValue
            self.rwNum = jsonData["rwNum"].stringValue
            self.rwPolicy = jsonData["rwPolicy"].stringValue
            self.rwPrice = jsonData["rwPrice"].stringValue
            self.rzNum = jsonData["rzNum"].stringValue
            self.rzPolicy = jsonData["rzPolicy"].stringValue
            self.rzPrice = jsonData["rzPrice"].stringValue
            self.saleDateTime = jsonData["saleDateTime"].stringValue
            self.startStationName = jsonData["startStationName"].stringValue
            self.startTime = jsonData["startTime"].stringValue
            self.swzNum = jsonData["swzNum"].stringValue
            self.swzPolicy = jsonData["swzPolicy"].stringValue
            self.swzPrice = jsonData["swzPrice"].stringValue
            self.tdzNum = jsonData["tdzNum"].stringValue
            self.tdzPolicy = jsonData["tdzPolicy"].stringValue
            self.tdzPrice = jsonData["tdzPrice"].stringValue
            self.toStationCode = jsonData["toStationCode"].stringValue
            self.toStationName = jsonData["toStationName"].stringValue
            self.trainCode = jsonData["trainCode"].stringValue
            self.trainNo = jsonData["trainNo"].stringValue
            self.trainStartDate = jsonData["trainStartDate"].stringValue
            self.trainType = jsonData["trainType"].stringValue
            self.wzNum = jsonData["wzNum"].stringValue
            self.wzPolicy = jsonData["wzPolicy"].stringValue
            self.wzPrice = jsonData["wzPrice"].stringValue
            
            
            self.ydzPrice = jsonData["ydzPrice"].stringValue
            self.ydzNum = jsonData["ydzNum"].stringValue
            self.ydzPolicy = jsonData["ydzPolicy"].stringValue
            self.ywPolicy = jsonData["ywPolicy"].stringValue
            self.ywNum = jsonData["ywNum"].stringValue
            self.ywPrice = jsonData["ywPrice"].stringValue
            self.yzNum = jsonData["yzNum"].stringValue
            self.yzPolicy = jsonData["yzPolicy"].stringValue
            self.yzPrice = jsonData["yzPrice"].stringValue
        }
        
    }
  
}


extension Array where Element == QueryTrainResponse.TrainAvailInfo {
    
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
        return self.filter{$0.isStart == (isStart == true  ? "1" : "0")}
    }
    
}
