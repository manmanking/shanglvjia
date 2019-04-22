//
//  CoNewExanimeForm.swift
//  shop
//
//  Created by akrio on 2017/5/27.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
/// 老版审批相关实体
struct CoNewExanimeForm {
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
        /// 审批意见
        let comment:String
        /// 当前审批级别
        let currentApvLevel:Int
        init(comment:String,currentApverLevel:Int) {
            self.comment = comment
            self.currentApvLevel = currentApverLevel
        }
    }
    /// 审批拒绝实体
    struct Reject :DictionaryAble{
        
        /// 审批意见
        let comment:String
    }
}
