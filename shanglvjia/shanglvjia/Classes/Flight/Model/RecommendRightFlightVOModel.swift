//
//  RecommendRightFlightVOModel.swift
//  shanglvjia
//
//  Created by manman on 2018/4/2.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class RecommendRightFlightVOModel: NSObject {
    
    ///  (Array[CommitFlightVO]): 需要查询匹配政策的航程信息 ,
    var flights:[CommitParamVOModel.CommitFlightVO] = Array()
    
    ///  (string, optional): 差旅政
    var travelPolicyId:String = ""
    
}
