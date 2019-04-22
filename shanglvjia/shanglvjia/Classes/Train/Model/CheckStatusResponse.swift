//
//  CheckStatusResponse.swift
//  shanglvjia
//
//  Created by manman on 2018/4/11.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON


class CheckStatusResponse: NSObject,ALSwiftyJSONAble {
    
    var failOrderNo:String = ""
    var msg:String = ""
    var status:String = ""
    var travelOrderNo:[String] = Array()
    override init() {
        
    }
    required init?(jsonData: JSON) {
        self.failOrderNo = jsonData["failOrderNo"].stringValue
        self.msg = jsonData["msg"].stringValue
        self.status = jsonData["status"].stringValue
        self.travelOrderNo = jsonData["travelOrderNo"].arrayValue.map{$0.stringValue}
    }
}
