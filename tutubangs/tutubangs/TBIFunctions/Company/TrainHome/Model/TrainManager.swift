//
//  TrainManager.swift
//  shanglvjia
//
//  Created by manman on 2018/4/10.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class TrainManager: NSObject {

    static let shareInstance = TrainManager()
    
    
    /// 单程
    private var startStation:QueryTrainResponse.TrainAvailInfo = QueryTrainResponse.TrainAvailInfo()
    
    /// 往返
    private var endStation:QueryTrainResponse.TrainAvailInfo = QueryTrainResponse.TrainAvailInfo()
    
    
    /// 火车搜索信息
    private var trainSearchCondition:TrainSearchConditionModel = TrainSearchConditionModel()
    
    private override init() {
        
    }
    
    
    func resetTrainInfo() {
        startStation = QueryTrainResponse.TrainAvailInfo()
        endStation = QueryTrainResponse.TrainAvailInfo()
        trainSearchCondition = TrainSearchConditionModel()
    }
    
    /// 保存火车 行程 出发站信息
    func trainStartStationStore(from:QueryTrainResponse.TrainAvailInfo) {
        startStation = from
    }
    
    func trainStartStationDraw()-> QueryTrainResponse.TrainAvailInfo {
        return startStation
    }
    
    
    
    /// 保存火车 行程 终点站 信息
    func trainEndStationStore(to:QueryTrainResponse.TrainAvailInfo) {
        endStation = to
    }
    
    func trainEndStationDraw()->QueryTrainResponse.TrainAvailInfo {
        return endStation
    }
    
    /// 保存火车搜索信息
    func trainSearchConditionStore(searchCondition:TrainSearchConditionModel) {
        trainSearchCondition = searchCondition
    }
    
    /// 提取火车搜索信息
    func trainSearchConditionDraw() -> TrainSearchConditionModel {
        return trainSearchCondition
    }
    
}
