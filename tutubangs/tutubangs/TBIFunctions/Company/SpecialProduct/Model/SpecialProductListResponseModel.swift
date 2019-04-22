//
//  SpecialProductListResponseModel.swift
//  shop
//
//  Created by manman on 2017/7/5.
//  Copyright © 2017年 zhangwangwang. All rights reserved.
//

import Foundation
import Moya_SwiftyJSONMapper
import SwiftyJSON
/// 特价产品
struct SpecialProductListResponseModel: ALSwiftyJSONAble,DictionaryAble{
    /// 特价产品id
    let productId:String!
    /// 特价产品名称
    let productName:String!
    /// 特价产品类型
    let productType:NSInteger!
    /// 原价
    let price:NSInteger!
    /// 售价
    let salePrice:NSInteger!
    /// 出发地
    let startCity:String!
    /// 目的地
    let arriveCity:String!
    /// 是否显示合同
    let showContract:String!
    /// 是否确认库存
    let confirm:String!
    /// 地域1国内2国际
    let region:NSInteger!
    //产品封面
    let imgUrl:String!
    /// 热度
    let hot:String!
    /// 产品描述
    let productDescription:String!
    /// 标签
    let label:String!
    
    init (jsonData jItem: JSON) {
        self.productId = jItem["pageIndex"].string
        self.productName = jItem["productName"].string
        self.productType = jItem["productType"].intValue
        self.price = jItem["price"].intValue
        self.salePrice = jItem["salePrice"].intValue
        self.startCity = jItem["startCity"].stringValue
        self.arriveCity = jItem["arriveCity"].stringValue
        self.showContract = jItem["showContract"].stringValue
        self.confirm = jItem["confirm"].stringValue
        self.region = jItem["region"].intValue
        self.imgUrl = jItem["imgUrl"].stringValue
        self.hot = jItem["hot"].stringValue
        self.productDescription = jItem["productDescription"].stringValue
        self.label = jItem["label"].stringValue
        
        
    }
}
