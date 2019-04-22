//
//  CoManagerListItem.swift
//  shop
//
//  Created by akrio on 2017/5/27.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import SwiftyJSON
import Moya_SwiftyJSONMapper

/// 企业新老版审批人实体
struct CoManagerListItem :ALSwiftyJSONAble{
    /// 审批人姓名
    var apverName:String
    /// 审批人唯一标识
    var apverUid:String
    /// 审批人邮箱
    var apverEmails:[String]
    init(jsonData: JSON) {
        self.apverName = jsonData["apverName"].stringValue
        self.apverUid = jsonData["apverUid"].stringValue
        self.apverEmails = jsonData["apverEmails"].arrayValue.map{ $0.stringValue }
    }
    /// 用于测试所需
    init(apverName:String,apverUid:String,apverEmails:[String]) {
        self.apverName = apverName
        self.apverUid = apverUid
        self.apverEmails = apverEmails
    }
}
