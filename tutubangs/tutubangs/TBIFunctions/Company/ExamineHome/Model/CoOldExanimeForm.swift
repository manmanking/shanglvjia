//
//  CoOldExanimeFrom.swift
//  shop
//
//  Created by akrio on 2017/5/27.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
/// 老版审批相关实体
struct CoOldExanimeForm {
    /// 查询实体
    struct SearchList:DictionaryAble {
        //  页码
        let offset:Int
        /// 每页条目
        let limit:Int
        /// 订单类型 nil 全部
        let state:String?
        init(offset:Int,limit:Int = 5,state:CoExamineState? = nil) {
            self.offset = offset
            self.limit = limit
            self.state = state?.rawValue
        }
    }
    /// 审批同意实体
    struct Agree :DictionaryAble{
        /// 下级审批人ID
        var nextApverId:String = ""
        /// 当前审批ID
        let currentApverId:String
        /// 当前审批级别
        let currentApvLevel:Int
        init(currentApverId:String,currentApverLevel:Int) {
            self.currentApverId = currentApverId
            self.currentApvLevel = currentApverLevel
        }
    }
    /// 审批拒绝实体
    struct Reject :DictionaryAble{
        /// 审批意见。
        let comment:String
        /// 当前审批ID
        let currentApverId:String
        /// 当前审批级别
        let currentApvLevel:Int
    }
}
/// 企业新老版通用查询审批状态
///
/// - waitApproval: 待审批
/// - agree: 已同意
/// - reject: 已拒绝
enum CoExamineState :String{
    case waitApproval = "0"
    case agree = "1"
    case reject = "2"
    case unknow = "unknow"
    
    init(type:String){
        
        if type == "0" {
            self = .waitApproval
        }else if type == "1" {
            self = .agree
        }else if type == "2" {
            self = .reject
        }else {
            self = .unknow
        }
        
        
    }
    
    
}
extension CoExamineState: CustomStringConvertible {
    var description: String {
        switch self {
        case .waitApproval:
            return "待审批"
        case .agree:
            return "已同意"
        case .reject:
            return "已拒绝"
        case .unknow:
            return "未知状态"
        }
    }
}
