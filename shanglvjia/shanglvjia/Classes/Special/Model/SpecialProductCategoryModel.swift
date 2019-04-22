//
//  SpecialProductCategoryModel.swift
//  shop
//
//  Created by manman on 2017/7/28.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON

class SpecialProductCategoryModel: NSObject,ALSwiftyJSONAble {

    //特价产品类型id
    var id:             String?
    //特价产品类型名称
    var productType:    String?
    
    override init() {
        super.init()
        
    }
    required init?(jsonData: SwiftyJSON.JSON)
    {
       self.id = jsonData["id"].stringValue
        self.productType = jsonData["productType"].stringValue
    }
}
