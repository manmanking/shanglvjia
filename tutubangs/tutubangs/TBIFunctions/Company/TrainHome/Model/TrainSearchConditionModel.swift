//
//  SearchTrainConditionModel.swift
//  shanglvjia
//
//  Created by manman on 2018/5/8.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class TrainSearchConditionModel: NSObject {
    
    /// 出发地城市
    var fromStationName:String = ""
    /// 到达城市
    var toStationName:String = ""
    /// 出发地城市三字码
    var fromStation:String = ""
    /// 到达城市三字码
    var toStation:String = ""
    /// 出发日期
    var departDate:String = ""
    /// 回程日期
    var returnDate:String = ""
    
    ///  出发时间 "yyyy-MM-dd HH:mm:ss"
    var departureDateFormat:String = ""
    
    /// 到达时间  "yyyy-MM-dd HH:mm:ss"
    var returnDateFormat:String = ""
    
    /// 是否只看高铁
    var isGt:Bool = false
    
    /// 单程0、去程1、回程2
    var type: Int = 0
    
    /// 去程 座位政策
    var fromPolicy:String = ""
    /// 回程 座位政策
    var toPolicy:String = ""
    
    ///  去程选中座位
    var fromSeat: SeatTrain = SeatTrain.defaultSeat
    
    ///  回程选中座位
    var toSeat: SeatTrain = SeatTrain.defaultSeat
    /// 出差城市
    var city:String = ""
    
    override init() {
        
    }
    
    

}
