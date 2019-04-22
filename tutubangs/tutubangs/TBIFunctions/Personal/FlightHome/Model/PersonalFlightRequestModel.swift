//
//  PersonalFlightRequestModel.swift
//  shanglvjia
//
//  Created by manman on 2018/8/8.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PersonalFlightRequestModel: CommitParamVOModel {
    
    
    ///  是否需要购买保险（1：是，0：否） ,
    var needInsurance:String = ""
    
    ///  0:不需要开发票；1：需要开发票 ,
    var needInvoice:String = ""
    
    
    ///  是否为国际机票（1：是，0：否）
    var isInterQuery:String = "0"
    
    ///订单类型（1:普通机票；2，特价机票；3定投机票） ,
   // var orderType:String = ""
    
    /// 产品编码 普通机票时为空
    var productNo:String = ""
    
    
    /// 发票信息
    var expense:VisaOrderAddResquest.VisaOrderExpenseResquest?
    
    ///保险
    var surances:[PTravelNearbyDetailModel.NearbySuranceResponse] = Array()
    

}
