//
//  TravelDetail.swift
//  shop
//
//  Created by TBI on 2017/6/30.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON

struct TravelDetail: ALSwiftyJSONAble {
    /// 特价产品id
    let productId:String
    /// 特价产品名称
    let productName:String
    /// 特价产品类型
    let productType:ProductType
    /// 原价
    let price:Double
    /// 售价
    let salePrice:Double
    /// 出发地
    let startCity:String
    /// 目的地
    let arriveCity:String
    /// 是否显示合同 0 false 1 true
    let showContract:Bool
    /// 是否确认库存
    let confirm:Bool
    /// 地域
    let region:TravelForm.Search.Region
    /// 产品封面
    let imgUrl:String
    /// 热度
    let hot:String
    /// 产品描述
    let productDescription:String
    
    init(jsonData: JSON) {
        self.productId = jsonData["productId"].stringValue
        self.productName = jsonData["productName"].stringValue
        self.productType = ProductType(rawValue: jsonData["productType"].intValue) ?? .unknow
        self.price = jsonData["price"].doubleValue
        self.salePrice = jsonData["salePrice"].doubleValue
        self.startCity = jsonData["startCity"].stringValue
        self.arriveCity = jsonData["arriveCity"].stringValue
        self.showContract = jsonData["showContract"].intValue == 1
        self.confirm = jsonData["confirm"].intValue == 1
        self.region = TravelForm.Search.Region(rawValue: jsonData["region"].intValue) ?? .unknow
        self.imgUrl = jsonData["imgUrl"].stringValue
        self.hot = jsonData["hot"].stringValue
        self.productDescription = jsonData["productDescription"].stringValue
    }


}
