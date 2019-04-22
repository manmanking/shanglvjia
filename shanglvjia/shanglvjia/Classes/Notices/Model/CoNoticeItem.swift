//
//  CoNoticeItem.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/6/20.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

import Moya_SwiftyJSONMapper
import SwiftyJSON
import SwiftDate

struct CoNoticeItem : ALSwiftyJSONAble
{
    /// 发布时间
    let pubDate:DateInRegion
    /// 标题
    let title:String
    /// 内容
    let content:String
    
    
    init(jsonData: JSON)
    {
        self.pubDate = jsonData["pubDate"].dateFormat(.unix)
        self.title = jsonData["title"].stringValue
        self.content = jsonData["content"].stringValue
    }
}
