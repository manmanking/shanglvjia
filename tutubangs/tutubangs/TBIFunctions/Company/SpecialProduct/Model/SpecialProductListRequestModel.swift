//
//  SpecialProductListRequestModel.swift
//  shop
//
//  Created by manman on 2017/7/5.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON
/// 特价产品
class SpecialProductListRequestModel:NSObject{
    /// 第几页
    var pageIndex:NSNumber?
    /// 一页显示多少
    var pageSize:NSNumber?
    /// 需要排序的列 hot--热度 sort--排序 sale_price--售价
    var orderByKey:String?
    /// 排序升降序 Asc--升序 Desc--降序
    var orderByAscDesc:String?
    /// 特价产品类型 1--机+酒 2--机票 3--机+专车 4--机+签证 5--酒+门票 6--酒+餐券 7--度假产品 8--旅游产品 产品类型可以多个，多个用,分割
    var productType:String?
    /// 出发地
    var startCity:String?
    /// 地域 1--国内 2--国际
    var region:String?
    /// 出发日期-- 开始
    var saleDateBegin:String?
    /// 出发日期--结束
    var saleDateEnd:String?
    /// 搜索关键字或目的地
    var searchKey:String?
    
    
//    init?(jsonData jItem: JSON) {
//        self.pageIndex = jItem["pageIndex"].intValue
//        self.pageSize = jItem["pageSize"].intValue
//        self.orderByKey = jItem["orderByKey"].stringValue
//        self.orderByAscDesc = jItem["orderByAscDesc"].stringValue
//        self.productType = jItem["productType"].stringValue
//        self.startCity = jItem["startCity"].stringValue
//        self.region = jItem["region"].stringValue
//        self.saleDateBegin = jItem["saleDateBegin"].stringValue
//        self.saleDateEnd = jItem["saleDateEnd"].stringValue
//        self.searchKey = jItem["searchKey"].stringValue
//        
//    }
    
    override init() {
        
    }
}
