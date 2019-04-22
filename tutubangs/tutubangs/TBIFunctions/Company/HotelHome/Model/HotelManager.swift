//
//  HotelManager.swift
//  shanglvjia
//
//  Created by manman on 2018/4/25.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class HotelManager: NSObject {
    
    private var hotelSearchCondition:HotelListRequest = HotelListRequest()
    private var hotelSearchParameter:HotelSearchParameter = HotelSearchParameter()
    
    
    private var cityCategoryRegionModel:CityCategoryRegionModel = CityCategoryRegionModel()
    
    static let shareInstance = HotelManager()
    
    private override init() {
        
    }
    
    
    ///所有 重置信息
   public  func resetAllSearchCondition() {
        hotelSearchCondition = HotelListRequest()
        cityCategoryRegionModel = CityCategoryRegionModel()
    }
    
    /// 部分重置信息
    public  func resetPartSearchCondition() {
        hotelSearchCondition.highRate = hotelSearchMaxPrice
        hotelSearchCondition.pageNum = 1
        hotelSearchCondition.lowRate = 0
        hotelSearchCondition.latitude = 0
        hotelSearchCondition.longitude = 0
        hotelSearchCondition.searchRegion = ""
        hotelSearchCondition.brandId = ""
        hotelSearchCondition.commericalId = ""
        hotelSearchCondition.districtId = ""
        hotelSearchCondition.hotelStarRate = ""
        hotelSearchCondition.landmarkId = ""
        hotelSearchCondition.radius = 0
        hotelSearchCondition.score = ""
        hotelSearchCondition.sId = ""
    }
    
    /// 重置部分信息
    /// 为地图模式 转到 列表模式 使用
    func resetPartSearchConditionForMap2Lsit() {
        hotelSearchCondition.latitude = 0
        hotelSearchCondition.longitude = 0
    }
    
    
    /// 保存 用户 搜索条件
   public func searchConditionUserStore(searchCondition:HotelListRequest) {
        self.hotelSearchCondition = searchCondition
    }
    
    /// 提取 用户 搜索条件
    func searchConditionUserDraw() ->HotelListRequest {
        return hotelSearchCondition
    }
    
    /// 保存当前城市 的行政区 商圈。品牌
   public func searchConditionCityCategoryRegionStore(cityCategoryRegionModel:CityCategoryRegionModel) {
        self.cityCategoryRegionModel = cityCategoryRegionModel
    }
    
   public func searchConditionCityCategoryRegionDraw() -> CityCategoryRegionModel {
        return cityCategoryRegionModel
    }
    
    /// 保存 用户 搜索条件
    public func searchParameterUserStore(searchCondition:HotelSearchParameter) {
        self.hotelSearchParameter = searchCondition
    }
    
    /// 提取 用户 搜索条件
    func searchParameterUserDraw() ->HotelSearchParameter {
        return hotelSearchParameter
    }

}
class HotelSearchParameter: NSObject {
    var hightStr : String = ""
    var lowStr : String = ""
    var recommendIndex : NSInteger = 0
    var levelIndex : NSInteger = 0
    var styleIndex : NSInteger = 0
    override init() {
        
    }
}
