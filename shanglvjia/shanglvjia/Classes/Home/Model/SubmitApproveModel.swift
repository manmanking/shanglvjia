//
//  SubmitApproveModel.swift
//  shanglvjia
//
//  Created by manman on 2018/5/14.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class SubmitApproveVO: NSObject {
    var submitApproveInfos:[SubmitApproveInfo] = Array()
    
    
    class SubmitApproveInfo: NSObject {
        var approveId:String = ""
        var approveLevel:String = ""
        var approveOrderInfos:[ApproveOrderInfo] = Array()
        var approveParInfos:[ApproveParInfo] = Array()
        var sendSms:String = ""
    }
    
    class ApproveOrderInfo: NSObject {
        
        ///  (string, optional): 订单ID ,
        var orderId:String = ""
        
        ///  (string, optional): 订单类型（1：机票，2：酒店，3：火车票，4：专车）
        var orderType:String = ""
    }
    class ApproveParInfo: NSObject {
        var approveLevel:String = ""// (string, optional),
        var parId:String = "" //(string, optional),
        var parName:String = ""// (string, optional)
    }
}
