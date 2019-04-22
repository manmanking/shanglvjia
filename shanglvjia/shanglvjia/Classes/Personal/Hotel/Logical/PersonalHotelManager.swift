//
//  PersonalHotelManager.swift
//  shanglvjia
//
//  Created by manman on 2018/8/4.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PersonalHotelManager: NSObject {
    
    
    static let shareInstance = PersonalHotelManager()
    
    private var hotelSearchCondition:PersonalNormalHotelListRequest = PersonalNormalHotelListRequest()
    
    private var cityCategoryRegionModel:CityCategoryRegionModel = CityCategoryRegionModel()
    
    
    
    private override init() {
        
    }
    
    
    ///所有 重置信息
    public  func resetAllSearchCondition() {
        hotelSearchCondition = PersonalNormalHotelListRequest()
        cityCategoryRegionModel = CityCategoryRegionModel()
    }
    
    
    
    /// 保存 用户 搜索条件
    public func searchConditionUserStore(searchCondition:PersonalNormalHotelListRequest) {
        self.hotelSearchCondition = searchCondition
    }
    
    /// 提取 用户 搜索条件
    func searchConditionUserDraw() ->PersonalNormalHotelListRequest {
        return hotelSearchCondition
    }
    
    /// 保存当前城市 的行政区 商圈。品牌
    public func searchConditionCityCategoryRegionStore(cityCategoryRegionModel:CityCategoryRegionModel) {
        self.cityCategoryRegionModel = cityCategoryRegionModel
    }
    
    public func searchConditionCityCategoryRegionDraw() -> CityCategoryRegionModel {
        return cityCategoryRegionModel
    }
    
    
    
    
    
    
    

}
