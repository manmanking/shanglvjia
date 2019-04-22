//
//  TravelListItem.swift
//  shop
//
//  Created by akrio on 2017/6/27.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import Moya_SwiftyJSONMapper
import SwiftyJSON

/// 旅游类型
///
/// - airHotel: 机+酒
/// - airTicket: 机票
/// - airCar: 机+专车
/// - airVisa: 机+签证
/// - hotelAdmission: 酒+门票
/// - hotelTicket: 酒+餐券
/// - holiday: 度假产品
/// - travel: 旅游产品
enum ProductType:Int {
    case airHotel = 1
    case airTicket = 2
    case airCar = 3
    case airVisa = 4
    case hotelAdmission = 5
    case hotelTicket = 6
    case holiday = 7
    case travel = 8
    case unknow = 999
}
//／ 旅游产品类型
///
/// - tbi: tbi
/// - cits: cits
enum TravelProductSource:Int {
    case tbi = 1
    case cits = 2
}


//下单反回
struct TravelResult:ALSwiftyJSONAble {
    
    ///订单号
    let orderNo:String
    ///错误原因
    let errorReason:String
    
    init(jsonData: JSON) {
        self.orderNo = jsonData["orderNo"].stringValue
        self.errorReason = jsonData["errorReason"].stringValue
    
    }
}

struct TravelListItem:ALSwiftyJSONAble {
    /// 特价产品id
    var productId:String?
    /// 特价产品名称
    var productName:String?
    /// 特价产品类型
    var productType:ProductType?
    /// 原价
    var price:Float?
    /// 售价
    var salePrice:Double?
    /// 出发地
    var startCity:String?
    /// 目的地
    var arriveCity:String?
    /// 是否显示合同 0 false 1 true
    var showContract:Bool?
    /// 是否确认库存
    var confirm:Bool?
    /// 地域
    var region:TravelForm.Search.Region?
    /// 产品封面
    var imgUrl:String?
    /// 热度
    var hot:String?
    /// 产品描述
    var productDescription:String?
    /// 产品所属
    var productFlag:TravelProductSource?
    
    init(jsonData: JSON) {
        self.productId = jsonData["productId"].stringValue
        self.productName = jsonData["productName"].stringValue
        self.productType = ProductType(rawValue: jsonData["productType"].intValue) ?? .unknow
        self.price = jsonData["price"].floatValue
        self.salePrice = jsonData["salePrice"].doubleValue
        self.startCity = jsonData["startCity"].stringValue
        self.arriveCity = jsonData["arriveCity"].stringValue
        self.showContract = jsonData["showContract"].intValue == 1
        self.confirm = jsonData["confirm"].intValue == 1
        self.region = TravelForm.Search.Region(rawValue: jsonData["region"].intValue) ?? .unknow
        self.imgUrl = jsonData["imgUrl"].stringValue
        self.hot = jsonData["hot"].stringValue
        self.productDescription = jsonData["productDescription"].stringValue
        self.productFlag = TravelProductSource(rawValue: jsonData["productFlag"].intValue)
    }
    
    init() {
        
    }
    
    
    }
