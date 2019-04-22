//
//  CoStationListItem.swift
//  shop
//  火车站信息
//  Created by TBI on 2017/12/26.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import SwiftyJSON
import Moya_SwiftyJSONMapper

struct  CoStationListItem: ALSwiftyJSONAble {
    
    var  id:Int
    
    /// 火车站名称
    var name:String
    
    /// 火车站拼音
    var py:String
    
    /// 火车站三字码
    var code:String
    
    /// 是否热门（1：热门，0：非热门）
    var ifhot:String
    
    /// 城市名称
    var city:String
    
    init(jsonData:JSON){
       self.id = jsonData["id"].intValue
       self.name = jsonData["name"].stringValue
       self.py = jsonData["py"].stringValue
       self.code = jsonData["code"].stringValue
       self.ifhot = jsonData["ifhot"].stringValue
       self.city = jsonData["city"].stringValue
    }
}
