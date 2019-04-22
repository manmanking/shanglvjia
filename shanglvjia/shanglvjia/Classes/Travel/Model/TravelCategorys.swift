//
//  TravelCategorys.swift
//  shop
//
//  Created by TBI on 2017/6/30.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON

struct TravelCategorys: ALSwiftyJSONAble {
    
    ///特价产品类型ID
    let categoryId:String
    
    ///特价产品类型名称
    let categoryName:String
    
    ///产品销售日期月份
    let firstMonth:String
    
    init(jsonData: JSON) {
        self.categoryId = jsonData["categoryId"].stringValue
        self.categoryName = jsonData["categoryName"].stringValue
        self.firstMonth = jsonData["firstMonth"].stringValue
    }
    
}
