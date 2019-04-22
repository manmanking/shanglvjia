//
//  OrderForm.swift
//  shop
//
//  Created by akrio on 2017/5/13.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
/// 订单查询实体
struct OrderSearchForm:DictionaryAble {
    //  页码
    let pageIndex:Int
    /// 每页条目
    let pageSize:Int
    /// 订单类型
    var orderType:String?
    /// 订单状态
    let orderStatus:Int?
    init(pageIndex:Int,pageSize:Int = 5,orderType:OrderType? = nil,orderStatus:OrderStatus? = nil) {
        self.pageIndex = pageIndex
        self.pageSize = pageSize
        self.orderType = orderType?.rawValue.description
        if orderType?.rawValue == 3 || orderType?.rawValue == 5 {
            self.orderType = "3,5"
        }else {
            self.orderType = orderType?.rawValue.description
        }
        self.orderStatus = orderStatus?.rawValue
    }
}

/// 订单状态 暂时瞎写的 因为乔彤生病 所以不知道每个状态位对应的是什么
///
/// - unpay: 未支付
/// - waitBook: 待订妥
/// - cancel: 已取消
/// - offline: 转线下
/// - unsubscribed: 已退单
/// - unsubscribing: 申请退订
/// - feedback: 已反馈
/// - complete: 已完成
/// - unknow: 未知状态
enum OrderStatus:Int {
    case unpay = 1
    case waitBook = 2
    case cancel = 3
    case offline = 4
    case unsubscribed = 5
    case unsubscribing = 6
    case feedback = 7
    case complete = 8
    case unknow = 9
}
extension OrderStatus:CustomStringConvertible {
    var description: String {
        switch self {
        case .unpay:
            return "未支付"
        case .waitBook:
            return "待订妥"
        case .cancel:
            return "已取消"
        case .offline:
            return "转线下"
        case .unsubscribed:
            return "已退单"
        case .unsubscribing:
            return "申请退订"
        case .feedback:
            return "已反馈"
        case .complete:
            return "已完成"
        case .unknow:
            return "未知"
        }
    }
}

/// 订单类型
///
/// - flight: 机票
/// - hotel: 酒店
/// - travel: 旅游
/// - special: 特价
enum OrderType:Int {
    case flight = 1
    case hotel = 2
    case travel = 3
    case special = 4
}
