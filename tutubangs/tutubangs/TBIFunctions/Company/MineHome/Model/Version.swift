//
//  Version.swift
//  shop
//
//  Created by TBI on 2018/2/26.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import SwiftyJSON
import Moya_SwiftyJSONMapper

struct Version: ALSwiftyJSONAble{
    
    /// 是否在审核期间
    var isAudit:Bool
    
    init (jsonData:JSON){
        self.isAudit = jsonData["audit"].boolValue
    }
} 
