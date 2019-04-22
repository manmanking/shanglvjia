//
//  HotelForm.swift
//  shop
//
//  Created by akrio on 2017/4/24.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
/// 酒店查询相关实体
struct HotelSearchForm:DictionaryAble{
    
    /// elongId
    var elongId:String = ""
    
    var commericalId:String = ""
    
    var hotelName:String = ""
    
    var landmarkId:String = ""
    
    /// 城市编码
    var cityId:String
    /// 城市名称
    var cityName:String
    /// 国家名称
    var countryCode:String?
    /// 子公司
    var subsidiary:HotelSubsidiary = HotelSubsidiary()
    
    var districtId:String?
    
    var districtTitle:String?
    
    /// 入住酒店时间
    var arrivalDate:String
    /// 离开酒店时间
    var departureDate:String
    /// 关键字
    var keyWord:String? = nil
    /// 星级
    var starRate:String? = nil
    /// 最小价格
    var lowRate:Int? = nil
    /// 最大价格
    var highRate:Int? = nil
    /// 排序方式
    var sort:String? = nil
    /// 支付方式
    var paymentType:String? = nil
    /// 经度
    var longitude:String? = nil
    /// 纬度
    var latitude:String? = nil
    /// 距离
    var radius:String? = nil
    /// 房间可容纳人数
    var checkInPersonAmount:String? = nil
    /// 第几页
    var pageIndex:Int = 1
    /// 一页显示多少
    var pageSize:Int = 10
    
    /// 排序规则
    ///
    /// - starRankDesc: 推荐星级降序
    /// - rateAsc: 价格升序
    /// - rateDesc: 价格降序
    /// - distanceAsc: 距离升序
    enum Sort:String {
        case starRankDesc = "StarRankDesc"
        case rateAsc = "RateAsc"
        case rateDesc = "RateDesc"
        case distanceAsc = "DistanceAsc"
    }
    /// 支付方式
    ///
    /// - selfPay: 现付
    /// - prePay: 预付
    enum PaymentType:String {
        case selfPay = "selfPay"
        case prePay = "prepay"
    }
    init(cityId:String,cityName:String,arrivalDate:Date,departureDate:Date) {
        self.cityId = cityId
        self.cityName = cityName
        self.arrivalDate = ""//arrivalDate.string(format: .custom("YYYY-MM-dd"))
        self.departureDate = ""//departureDate.string(format:.custom("YYYY-MM-dd"))
    }
    init(){
        self.init(cityId: "", cityName: "", arrivalDate: Date(), departureDate: Date())
    }
    func getDurationDay() -> Int?{
        guard let arriveDate = arrivalDate.date(format: .custom("YYYY-MM-dd")),let depDate = departureDate.date(format: .custom("YYYY-MM-dd")) else{
            return nil
        }
        return (depDate.timeIntervalSinceReferenceDate - arriveDate.timeIntervalSinceReferenceDate).in(.day)
    }
}

/*
 * 酒店详情查询条件
 */
struct HotelDetailForm:DictionaryAble{
    /// 酒店id
    var hotelId:String
    /// 入住酒店时间
    var arrivalDate:String
    /// 离开酒店时间
    var departureDate:String
    
    
    init(hotelId:String,arrivalDate:Date,departureDate:Date) {
        self.hotelId = hotelId
        self.arrivalDate = arrivalDate.string(format: .custom("YYYY-MM-dd"))
        self.departureDate = departureDate.string(format:.custom("YYYY-MM-dd"))
    }
    init(){
        self.init(hotelId: "", arrivalDate: Date(), departureDate: Date())
    }
}


