//
//  RecommendFlightResultVOModel.swift
//  shanglvjia
//
//  Created by manman on 2018/4/2.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON


class RecommendFlightResultVOModel: NSObject,ALSwiftyJSONAble{
   
    

    ///  (boolean, optional): 请求仓位是否违反差旅政策 , true 违背。false 符合 
    var contraryPolicy:Bool = false
    
    ///  (string): 查询符合政策的航班ID ,
    var flightCacheId:String = ""
    
    ///  (SearchResultVO): 符合政策的航班仓位信息
    var result:FlightSVSearchResultVOModel = FlightSVSearchResultVOModel()
    
    
    override init() {
        
    }
    
    required init?(jsonData: JSON) {
        self.contraryPolicy = jsonData["contraryPolicy"].boolValue
        self.flightCacheId = jsonData["flightCacheId"].stringValue
        self.result = FlightSVSearchResultVOModel.init(jsonData:jsonData["result"])!
    }
    
    
}
