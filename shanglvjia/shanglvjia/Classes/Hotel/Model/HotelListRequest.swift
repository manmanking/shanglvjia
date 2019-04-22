//
//  HotelListRequest.swift
//  shanglvjia
//
//  Created by manman on 2018/4/24.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class HotelListRequest: NSObject {
    
    
    ///  (string, optional): 城市id ,
    var cityId:String = ""
    ///  (string, optional): 城市name ,
    var cityName:String = ""
    
    
    /// 当前 定位 城市 id
    var currentCityId:String = ""
    
    /// 当前 定位 城市 名称
    var currentCityName:String = ""
    
    var mapType:String = "1"
    
    ///  酒店当前城市的 差标价格
    var currentPolicyPrice:String = ""
  
    
    ///  (string, optional): 公司code ,
    var corpCode:String = ""
    
    /// 离店时间 "yyyy-MM-dd HH:mm:ss"
    var departureDateFormat:String = ""
    
    /// 入住时间  "yyyy-MM-dd HH:mm:ss"
    var arrivalDateFormat:String = ""
    
    /// 离店时间   时间戳
    var departureDate:String = ""
    
    /// 入住时间  时间戳
    var arrivalDate:String = ""
    
    
    /// 地标商圈 行政区 显示 
    var searchRegion:String = ""
    
    
    ///  (string, optional): 行政区id ,
    var districtId:String = ""
    
    var districtRegion:CityCategoryRegionModel.RegionModel =  CityCategoryRegionModel.RegionModel()
    
    ///  (string, optional): 地标id ,
    var landmarkId:String = ""
    
    var landmarkName:String = ""
    
    var landmarkRegion:CityCategoryRegionModel.RegionModel =  CityCategoryRegionModel.RegionModel()
    
    
    ///  (string, optional): 商圈id ,
    var commericalId:String = ""
    
    var commericalRegion:CityCategoryRegionModel.RegionModel =  CityCategoryRegionModel.RegionModel()
    
    ///  (Array[string], optional): 分公司信息 ,
    var groupCodes:[String] = Array()
    
    /// 分公司全部信息
    var filialeItem:FilialeItemModel = FilialeItemModel()
    
    
    ///  (integer, optional): 最高价 ,
    var highRate:NSInteger = hotelSearchMaxPrice
    
    ///  (string, optional): 关键字 ,
    var keyword:String = ""
    

    
    ///  (number, optional): 纬度 ,
    var latitude:Double = 0
    
    ///  (number, optional): 经度 ,
    var longitude:Double = 0
    
    ///  (number, optional): 纬度 ,
    var userLatitude:Double = 0
    
    ///  (number, optional): 经度 ,
    var userLongitude:Double = 0
    
    ///  (integer, optional): 最低价 ,
    var lowRate:NSInteger = 0
    
    ///  (Array[string], optional): 入住人id ,
    var parIds:[String] = Array()
    
    ///  (integer, optional): 半径 ,
    var radius:NSInteger = 0
    
    var radiusTitle:String = ""
    
    ///  (string, optional): 查询id用来记录查询的连贯性 ,
    var sId:String = ""
    
    ///  (string, optional): 酒店推荐指数 ,
    var score:String = ""
    
    ///  (string, optional): 酒店名称 ,
    var hotelName:String = ""
    
    ///  (string, optional): 酒店星级 ,
    var hotelStarRate:String = ""
    
    ///  (integer, optional): 排序方式
    var sortType:String = ""
    
    ///  (integer, optional): 支付方式 ,
    var payType:NSInteger = 2
    
    ///  (string, optional): 品牌id ,
    var brandId:String = ""
    
    ///  (integer, optional): 页数 ,
    var pageNum:NSInteger = 1
    
    ///  (integer, optional): 大小 ,
    var pageSize:NSInteger = 10
    
    override init() {
        
    }
    
   class func hotelSearchFormConvertToHotelListRequest(searchCondition:HotelSearchForm) -> HotelListRequest {
    
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
        let request:HotelListRequest = HotelListRequest()
    
        //request.brandId = searchCondition
        request.cityId = searchCondition.cityId
        request.commericalId = searchCondition.commericalId
        //request.corpCode = searchCondition.
    
        let arriveDateStr:String = searchCondition.arrivalDate + " 23:59"
        let arriveDate:Date = dateFormatter.date(from: arriveDateStr)!
    
        request.arrivalDate = (NSInteger(arriveDate.timeIntervalSince1970) * 1000).description
        let departureDateStr:String = searchCondition.departureDate + " " + Date().string(custom: "HH:mm")
        let departureDate:Date = dateFormatter.date(from: departureDateStr)!
    
        request.departureDate = (NSInteger(departureDate.timeIntervalSince1970) * 1000).description
        request.districtId = searchCondition.districtId ?? ""
        
        request.groupCodes = [searchCondition.subsidiary.branchName]
        request.highRate = searchCondition.highRate ?? 0
        request.hotelName = searchCondition.hotelName
        request.hotelStarRate = ((NSInteger(searchCondition.starRate ?? "0") ?? 0) * 2).description
        request.keyword = ""//earchCondition.keyWord ?? ""
        request.landmarkId = searchCondition.landmarkId
        request.latitude = Double(searchCondition.latitude ?? "0") ?? 0
        request.longitude = Double(searchCondition.longitude ?? "0") ?? 0
        request.lowRate = searchCondition.lowRate ?? 0
        request.pageNum = searchCondition.pageIndex
        request.pageSize = searchCondition.pageSize
        //request.parIds = searchCondition.
        //request.payType = ""
        //request.radius =
        request.score = ((NSInteger(searchCondition.starRate ?? "0") ?? 0) * 2).description
        request.sId = ""
       // request.sortType = searchCondition.sort
        
        
        return request
    }
    
    
    
    

}
