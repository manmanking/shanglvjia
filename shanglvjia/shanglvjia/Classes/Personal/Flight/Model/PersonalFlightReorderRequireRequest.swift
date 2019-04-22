//
//  PersonalFlightReorderRequireRequest.swift
//  shanglvjia
//
//  Created by manman on 2018/8/24.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PersonalFlightReorderRequireRequest: NSObject {

    ///  (Array[CommitFlightVO]): 需要生单的航程信息 ,
    var flights:[CommitParamVOModel.CommitFlightVO] = Array()
    var orderId:String = ""
    var passagerIds:[String] = Array()
    var orderNo:String = ""
    var orderStatus:String = ""
    var requireDetail:String = ""
    
}
