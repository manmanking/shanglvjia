//
//  CoCommonModel.swift
//  shop
//
//  Created by akrio on 2017/5/28.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
/// 审批状态
///
/// - wait: 待审批
/// - agree: 已同意
/// - reject: 已拒绝
enum ExanimeState:String {
    case wait = "1"
    case agree = "2"
    case reject = "3"
    case unknow = "unknow"
}
extension ExanimeState:CustomStringConvertible {
    var description:String {
        switch self {
        case .wait:
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
