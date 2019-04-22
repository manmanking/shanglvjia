//
//  PersonalOrderCountResponseVO.swift
//  shanglvjia
//
//  Created by manman on 2018/5/24.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import SwiftyJSON
import Moya_SwiftyJSONMapper

class PersonalOrderCountResponseVO: NSObject,ALSwiftyJSONAble {

    
    ///  (integer, optional): 待我审批 ,
    var approving:NSInteger = 0
    
    ///  (integer, optional): 计划中 ,
    var planning:NSInteger = 0
    
    ///  (integer, optional): 已定妥 ,
    var ticketed:NSInteger = 0
    
    ///  (integer, optional): 待定托 ,
    var waitForTicket:NSInteger = 0
    
    ///  (integer, optional): 审批中
    var waitForapprove:NSInteger = 0
    
    
    override init() {
        
    }
    
    
    required init?(jsonData: JSON) {
        approving = jsonData["approving"].intValue
        planning = jsonData["planning"].intValue
        ticketed = jsonData["ticketed"].intValue
        waitForTicket = jsonData["waitForTicket"].intValue
        waitForapprove = jsonData["waitForapprove"].intValue
    }
    
    
}
