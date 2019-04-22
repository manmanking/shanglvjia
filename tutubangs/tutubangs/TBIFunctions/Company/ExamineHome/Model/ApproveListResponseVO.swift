//
//  ApproveListResponseVO.swift
//  shanglvjia
//
//  Created by manman on 2018/5/16.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import SwiftyJSON
import Moya_SwiftyJSONMapper

class ApproveListResponseVO: NSObject,ALSwiftyJSONAble {
    
    var approveListInfoList:[ApproveListInfo] = Array()
    
    ///  (integer, optional): 总数
    var count:NSInteger = 0
    
    override init() {
        
    }
    required init?(jsonData: JSON) {
        count = jsonData["count"].intValue
        approveListInfoList = jsonData["approveListInfoList"].arrayValue.map{ApproveListInfo.init(jsonData:$0)! }
    }
    
    
    
    
    class ApproveListInfo: NSObject,ALSwiftyJSONAble {
        
        ///  (Array[], optional): 审批单下订单信息 ,
        var approveListOrderInfos:[ApproveListOrderInfo] = Array()
        
        ///  (string, optional): 审批单NO. ,
        var approveNo:String = ""
        
        ///  (string, optional): 审批单新建时间 ,
        var createTime:String = ""
        
        ///  (string, optional): 审批状态（0：待审批，1：已通过，2：已拒绝）
        var status:String = ""
        
        var selected:Bool = false
        
        override init() {
            
        }
        
        required init?(jsonData: JSON) {
            approveNo = jsonData["approveNo"].stringValue
            createTime = jsonData["createTime"].stringValue
            status = jsonData["status"].stringValue
            approveListOrderInfos = jsonData["approveListOrderInfos"].arrayValue.map{ApproveListOrderInfo.init(jsonData: $0)!}
            for element in approveListOrderInfos {
                element.approvalCreateTime = self.createTime
            }
            
            
        }
        
        
    }
    
    
    class ApproveListOrderInfo:NSObject,ALSwiftyJSONAble {
        
        
        
        ///  (number, optional): 订单总金额 ,
        var amount:String = ""
        
        ///  (string, optional): 审批单编号 ,
        var approveNo:String = ""
        
        ///  (integer, optional): 审批单新建时间 ,
        var approvalCreateTime:String = ""
        
        ///  (integer, optional): 订单新建时间 ,
        var createTime:String = ""
        
        ///  (string, optional): 订单详情 ,
        var orderDetail:String = ""
        
        ///  (string, optional): 订单号 ,
        var orderId:String = ""
        
        ///  (string, optional): 订单编号 ,
        var orderNo:String = ""
        
        ///  (string, optional): 订单标题（app用) ,
        var orderTitle:String = ""
        
        ///  (string, optional): 订单类型（1：机票，2：酒店，3：火车票，4：专车） ,
        var orderType:String = ""
        
        ///  (string, optional): 订单乘客信息
        var psgName:String = ""
        
        override init() {
            
        }
        
        required init?(jsonData: JSON) {
            amount = jsonData["amount"].stringValue
            approveNo = jsonData["approveNo"].stringValue
            createTime = jsonData["createTime"].stringValue
            orderDetail = jsonData["orderDetail"].stringValue
            orderId = jsonData["orderId"].stringValue
            orderNo = jsonData["orderNo"].stringValue
            orderTitle = jsonData["orderTitle"].stringValue
            orderType = jsonData["orderType"].stringValue
            psgName = jsonData["psgName"].stringValue
        }
        
        
    }
    
    
    
    
    

}
