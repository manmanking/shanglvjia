//
//  PersonalFlightManager.swift
//  shanglvjia
//
//  Created by tbi on 2018/8/7.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PersonalSpecialFlightManager: NSObject {

    /// 选中的 机票信息 列表
    private var selectedFlightInfos:[PSepcailFlightCabinModel.ResponsesListVo] = Array()
    private var selectedFlightInfoArr:[PersonalSpecialFlightInfoListResponse.BaseFlightAndReturnInfoVo] = Array()
    static let shareInStance = PersonalSpecialFlightManager()
    private override init() {
        
    }
    
    //MARK:----------机票----------------
    /// 添加 机票 信息
    func addPersonalSelectedFlightTrip(searchCondition:PSepcailFlightCabinModel.ResponsesListVo,tripSection:NSInteger) {
        if selectedFlightInfos.count < tripSection { selectedFlightInfos.append(searchCondition) }
        else {selectedFlightInfos[tripSection - 1] = searchCondition }
    }
//    /// 提取机票信息 提取
//    func selectedFlightTripDraw() -> [PSepcailFlightCabinModel.ResponsesListVo] {
//        return selectedFlightInfos
//    }
//
//    func personalSelectedFlightTripStore(flightTripArr:[PSepcailFlightCabinModel.ResponsesListVo]) {
//        selectedFlightInfos = flightTripArr
//    }
//
    
    
    /// 提取机票信息 提取
    func selectedFlightTripInfoDraw() -> [PersonalSpecialFlightInfoListResponse.BaseFlightAndReturnInfoVo] {
        return selectedFlightInfoArr
    }
    
    func selectedFlightTripInfoStore(flightTripArr:[PersonalSpecialFlightInfoListResponse.BaseFlightAndReturnInfoVo]) {
        selectedFlightInfoArr = flightTripArr
    }
    
    
    
    
    
    
    
    func resetAllFlightInfo()
    {
        if selectedFlightInfos.count > 0 {
            selectedFlightInfos.removeAll()
        }
    }
    
}
