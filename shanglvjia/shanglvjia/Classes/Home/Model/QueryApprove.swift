//
//  QueryApprove.swift
//  shop
//
//  Created by manman on 2018/5/14.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import SwiftyJSON
import Moya_SwiftyJSONMapper

/// 审批结果
class QueryApproveResponseVO: NSObject ,ALSwiftyJSONAble{
    
    ///  (Array[], optional): 审批分组信息 ,
    var approveGroupInfos:[ApproveGroupInfo] = Array()
    
    /// //, optional): 送审失败订单信息 ,
    var failOrderInfos:[ApproveOrderInfo] = Array()
    
    ///  (string, optional): 送审失败原因 ,
    var msg:String = ""

    ///  (string, optional): 审批人获取状态（0：成功，-1：有订单送审失败）
    var status:String = ""
    
    override init() {
        
    }
    
    required init?(jsonData: JSON) {
        approveGroupInfos = jsonData["approveGroupInfos"].arrayValue.map{ApproveGroupInfo.init(jsonData: $0)!}
        failOrderInfos =  jsonData["pics_0"].arrayValue.map{ApproveOrderInfo(jsonData:$0)!}
        msg =  jsonData["msg"].stringValue
        status =  jsonData["status"].stringValue
    }
    
    
    class ApproveGroupInfo: NSObject,ALSwiftyJSONAble {
        
        ///  (integer, optional): 组内总审批等级 ,
        var approveLevel:String = ""
        
        /// , optional): 组内订单信息 ,
        var approveOrderInfos:[ApproveOrderInfo]  = Array()
        
        ///  (inline_model_0, optional): 各个等级对应的审批人列表（key是审批等级，VALUE是该级别的所有可选审批人） ,
        var approveParInfo:ApproveParInfo = ApproveParInfo()
        
        ///  (string, optional): 选择审批人类型（1送审只能选择第一级审批人；2送审可以选择所有级别审批人） ,
        var approveType:String = ""
        
        ///  (string, optional): 审批ID
        var aproveId:String = ""
        
        
        override init() {
            
        }
        required init?(jsonData: JSON) {
            approveLevel = jsonData["approveLevel"].stringValue
            approveOrderInfos =  jsonData["approveOrderInfos"].arrayValue.map{ApproveOrderInfo(jsonData:$0)!}
            approveParInfo = ApproveParInfo.init(jsonData:jsonData["approveParInfo"])!
            approveType =  jsonData["approveType"].stringValue
            aproveId = jsonData["aproveId"].stringValue
        }
        
    }
    
    class ApproveOrderInfo: NSObject,ALSwiftyJSONAble {
        
        ///  (string, optional): 订单ID ,
        var orderId:String = ""
        
        ///  (string, optional): 订单类型（1：机票，2：酒店，3：火车票，4：专车）
        var orderType:String = ""
        
        
        override init() {
            
        }
        
        required init?(jsonData: JSON) {
            orderId = jsonData["orderId"].stringValue
            orderType =  jsonData["orderType"].stringValue
        }
    }
    
    
    class ApproveParInfo: NSObject ,ALSwiftyJSONAble{
        var firstLevel:[ApprovePerInfo] = Array()
        var secondLevel:[ApprovePerInfo] = Array()
        var thirdLevel:[ApprovePerInfo] = Array()
        var forthLevel:[ApprovePerInfo] = Array()
        var fifthLevel:[ApprovePerInfo] = Array()
        
        override init() {
            
        }
        required init?(jsonData: JSON) {
            firstLevel = jsonData["1"].arrayValue.map{ ApprovePerInfo.init(jsonData:$0)!}
            secondLevel = jsonData["2"].arrayValue.map{ ApprovePerInfo.init(jsonData:$0)!}
            thirdLevel = jsonData["3"].arrayValue.map{ ApprovePerInfo.init(jsonData:$0)!}
            forthLevel = jsonData["4"].arrayValue.map{ ApprovePerInfo.init(jsonData:$0)!}
            fifthLevel = jsonData["5"].arrayValue.map{ ApprovePerInfo.init(jsonData:$0)!}
        }
        
        
        
    }
    
    class ApprovePerInfo:NSObject ,ALSwiftyJSONAble {
        var approveLevel:String = ""
        var parId:String = ""
        var parName:String = ""
        override init() {
            
        }
        required init?(jsonData: JSON) {
            approveLevel = jsonData["approveLevel"].stringValue
            parId =  jsonData["parId"].stringValue
            parName = jsonData["parName"].stringValue
        }
    }
    
    
    
}


/// 审批请求
class QueryApproveVO: NSObject {
    
    var status : String = ""
    var type : String = ""
    var orderType : String = ""
    var orderId : String = ""
    var id : String = ""
    var orderNo : String = ""
    
    /// , optional): 送审订单信息
    var approveOrderInfos:[ApproveOrderInfo] = Array()
    
    class ApproveOrderInfo: NSObject {
        
        ///  (string, optional): 订单ID ,
        var orderId:String = ""
        
        ///  (string, optional): 订单类型（1：机票，2：酒店，3：火车票，4：专车）
        var orderType:String = ""
        
        override init() {
            
        }
        
    }
    
    /// , optional): 取消审批
    var orderApproveInfos:[orderApproveInfo] = Array()
    
    class orderApproveInfo: NSObject {
        
        ///  (string, optional): 订单ID ,
        var orderId:String = ""
        
        ///  (string, optional): 订单类型（1：机票，2：酒店，3：火车票，4：专车）
        var orderType:String = ""
        
        var approveId:String = ""
        
        override init() {
            
        }
        
    }
    
    
}
