//
//  CoOrderForm.swift
//  shop
//
//  Created by akrio on 2017/5/15.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import RxSwift
/// 创建出差单实体
struct ModifyAndCreateCoNewOrderFrom :DictionaryAble{
    /// 审批规则id
    var apvRuleId:String
    /// 成本中心名称
    var costCenterNames:[String]
    /// 成本中心id
    var costCenterIds:[String]
    /// 出发日期 unix时间戳
    var departureDate:String = ""
    /// 返回日期 unix时间戳
    var returnDate:String = ""
    /// 出差目的
    var purpose:String
    /// 出差事由
    var reason =  Variable("")
    /// 出差地
    var destinations = [Variable("")]
    /// 常客ids
    var uids:[String]
    /// 自定义字段
    var opinions:[CustomFieldPara]?
    /// 自定义字段实体
    struct CustomFieldPara:DictionaryAble {
        /// 自定义字段唯一标识
        var id:String?
        /// 已创建订单中的唯一标识
        var resultId:String?
        /// 选中值
        var value:String?
        init (id:String ,value:String){
            self.id = id
            self.value = value
        }
        
        init (){
            id = ""
            value = ""
        }
    }
    init (){
        apvRuleId = ""
        costCenterNames = []
        costCenterIds = []
        departureDate = ""
        returnDate = ""
        purpose = ""
        uids = []
    }
}
/// 企业新版订单送审
struct CoNewOrderSubmit:DictionaryAble{
    /// 各级审批人Id
    let apverIds:[String]?
}
struct CoNewOrderSearchFrom : DictionaryAble{
    var offset:Int = 1
    var limit:Int = 5
    var state:String? = nil
    init(offset:Int = 1,limit:Int = 5,state:CoOrderState? = nil) {
        self.offset = offset
        self.limit = limit
        self.state = state?.rawValue
    }
    
}

/// 新版出查单状态
///
/// - cancel: 已取消
/// - planing: 计划中
/// - approving: 审批中
/// - passed: 已通过
/// - rejected: 已拒绝
/// - willComplete: 待定妥
/// - ompleted: 已定妥
/// - offline: 转线下
/// - sendBack: 订单退回
/// - canceling: 申请取消
/// - applying: 申请中
/// - deleted: 已删除
/// - deleting: 申请删除
/// - unknow: 未知的状态
//enum CoNewOrderState:String {
//    case cancel = "0"
//    case planing  =  "1"
//    case approving = "2"
//    case passed = "3"
//    case rejected = "4"
//    case willComplete = "5"
//    case ompleted = "6"
//    case offline = "8"
//    case sendBack = "9"
//    case canceling = "c"
//    case applying = "e"
//    case deleted = "n"
//    case deleting = "d"
//    case unknow = "unknow"
//}
//extension CoNewOrderState : CustomStringConvertible {
//    var description: String {
//        switch self {
//        case .cancel :
//            return "已取消"
//        case .planing  :
//            return "计划中"
//        case .approving:
//            return "审批中"
//        case .passed :
//            return "已通过"
//        case .rejected :
//            return "已拒绝"
//        case .willComplete :
//            return "待订妥"
//        case .ompleted :
//            return "已订妥"
//        case .offline :
//            return "转线下"
//        case .sendBack :
//            return "订单退回"
//        case .canceling :
//            return "申请取消"
//        case .applying :
//            return "申请中"
//        case .deleted :
//            return "已删除"
//        case .deleting :
//            return "申请删除"
//        case .unknow :
//            return "未知的状态"
//        }
//    }
//}
//// MARK: - 每个状态对应颜色
//extension CoNewOrderState {
//    var color: UIColor {
//        switch self {
//        case .cancel,.deleted,.offline :
//            return UIColor(r: 136, g: 136, b: 136)
//        case .planing  :
//            return UIColor(r: 70, g: 162, b: 255)
//        case .approving,.applying:
//            return UIColor(r: 152, g: 109, b: 178)
//        case .passed,.ompleted :
//            return UIColor(r: 49, g: 193, b: 124)
//        case .rejected,.sendBack :
//            return UIColor(r: 230, g: 67, b: 64)
//        case .willComplete,.canceling,.deleting :
//            return UIColor(r: 255, g: 93, b: 7)
//        case .unknow :
//            return UIColor.darkGray
//        }
//    }
//}
