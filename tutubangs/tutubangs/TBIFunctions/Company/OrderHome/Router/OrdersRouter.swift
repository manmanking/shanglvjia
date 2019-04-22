//
//  OrdersRouter.swift
//  shop
//
//  Created by akrio on 2017/5/12.
//  Copyright © 2017年 TBI. All rights reserved.
//


//travelOrderDetails   旅游订单详情
//cancelOrder    取消订单

import Foundation
import Moya

enum OrdersRouter {
    case list([String:Any])
    case flight(orderNo:String)
    case hotel(orderNo:String)
    case travelOrderDetails(orderNo:String)
    case cancelOrder(orderNo:String)
}
extension OrdersRouter:TargetType{
    /// 请求的基础路径
    var baseURL:URL {return URL(string: "\(BASE_URL)")!}
    /// 拼接路径
    var path:String{
        switch self {
        case .list:
            return "/orders"
        case .flight(let orderNo):
            return "/flight/orders/\(orderNo)"
        case .hotel(let orderNo):
            return "/hotel/orders/\(orderNo)"
        case .travelOrderDetails(let orderNo):
            return "/special/orders/\(orderNo)"
        case .cancelOrder(let orderNo):
            return "/alipay/\(orderNo)/handleCancleOrder"
        }
    }
    /// 请求方法
    var method:Moya.Method{
        switch self {
        case .list,.flight,.hotel,.travelOrderDetails,.cancelOrder:
            return .get
        }
    }
    /// 请求参数
    var parameters:[String:Any]?{
        switch self {
        case .list(let params):
            return params
        case .cancelOrder:
            return nil
        case .flight,.hotel,.travelOrderDetails:
            return nil
        }
    }
    /// 请求参数的发送方式
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .list,.flight,.hotel,.travelOrderDetails,.cancelOrder:
            return TokenURLEncoding.default
        }
    }
    /// 请求类型 如普通请求，发送文件，下载文件
    var task: Task {
        return .request
    }
    /// 单元测试所需
    var sampleData: Data {
        return Data()
    }
}
