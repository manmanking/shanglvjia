//
//  PCancelOrderResponse.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/7/11.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON
import Moya_SwiftyJSONMapper

struct PCancelOrderResponse:HandyJSON,ALSwiftyJSONAble
{
    
}

extension PCancelOrderResponse
{
    init?(jsonData: JSON)
    {
        let jsonStr = jsonData.description
        self = getNewInstance(jsonStr: jsonStr)
    }
    
    func getNewInstance(jsonStr:String) -> PCancelOrderResponse
    {
        return PCancelOrderResponse.deserialize(from: jsonStr)!
    }
}
