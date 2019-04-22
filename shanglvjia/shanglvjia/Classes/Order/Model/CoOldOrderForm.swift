//
//  CoOldOrderForm.swift
//  shop
//
//  Created by akrio on 2017/5/15.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
/// 老版订单相关表单项
struct CoOldOrderForm {
    /// 列表查询条件
    struct ListSearch:DictionaryAble {
        /// 页码
        let offset:Int
        /// 每页显示条目
        let limit:Int
        /// 订单状态 nil查询全部
        let state:String?
        init(offset:Int = 0,limit:Int = 5,state:CoOrderState? = nil) {
            self.offset = offset
            self.limit = limit
            self.state = state?.rawValue
        }
    }
    /// 送审实体
    struct Submit:DictionaryAble {

        /// 一级审批人ID(不传为提交，传为送审)
        let firstApverId:String?
        /// 一级审批人名称(不传为提交，传为送审)
        let firstApverName:String?
        /// 审批人ID (不传为提交，传为送审)
        let apverIds:[String]?
        /// 出行目的(不传为提交，传为送审)
        let purpose:String?
        /// 出行目的描述(不传为提交，传为送审)
        let description:String?
        init(orderNo:String) {
            self.firstApverId = nil
            self.firstApverName = nil
            self.apverIds = nil
            self.purpose = nil
            self.description = nil
        }
        init(firstApverId:String,firstApverName:String,apverIds:[String],purpose:String,description:String) {
            self.firstApverId = firstApverId
            self.firstApverName = firstApverName
            self.apverIds = apverIds
            self.purpose = purpose
            self.description = description
        }
    }
}
