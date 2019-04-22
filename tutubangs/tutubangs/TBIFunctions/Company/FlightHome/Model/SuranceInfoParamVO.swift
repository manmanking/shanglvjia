//
//  SuranceInfoParamVO.swift
//  shanglvjia
//
//  Created by manman on 2018/3/27.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class SuranceInfoParamVO: NSObject {

    ///(Array[CommitFlightVO]): 需要生单的航程信息 ,
    var flights:[CommitParamVOModel.CommitFlightVO] = Array()
    
    ///  (Array[TravellerCommitInfoVO]): 旅客
    var passangers:[CommitParamVOModel.TravellerCommitInfoVO] = Array()
    
    
}
