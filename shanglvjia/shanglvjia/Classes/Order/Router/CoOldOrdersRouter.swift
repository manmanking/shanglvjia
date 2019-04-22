//
//  OldOrdersRouter.swift
//  shop
//
//  Created by akrio on 2017/5/15.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import Moya
/// 企业老版订单相关router
///
/// - list: 订单列表
/// - detail: 订单详情
/// - revokeOrder: 撤销
/// - cancelOrder: 取消订单
/// - confirmOrder: 订单转为待定妥
/// - submitOrder: 送审|提交
/// - managers: 获取审批人
enum CoOldOrdersRouter {
    case list([String:Any])
    case detail(String)
    case revokeOrder(String)
    case cancelOrder(String)
    case confirmOrder(String)
    case submitOrder(String,[String:Any]?)
    case managers(String)
}
extension CoOldOrdersRouter:TargetType{
    /// 请求的基础路径
    var baseURL:URL {return URL(string: "\(BASE_URL)/company/old_orders")!}
    /// 拼接路径
    var path:String{
        switch self {
        case .list:
            return "/lite"
        case .detail(let id):
            return "/\(id)"
        case .cancelOrder(let id):
            return "/\(id)/cancel"
        case .confirmOrder(let id):
            return "/\(id)/confirm"
        case .revokeOrder(let id):
            return "/\(id)/approvals/revoke"
        case .submitOrder(let id,_):
            return "/\(id)/submit"
        case .managers(let id):
            return "/\(id)/managers"

        }
    }
    /// 请求方法
    var method:Moya.Method{
        switch self {
        case .list,.detail,.managers:
            return .get
        case .cancelOrder,.confirmOrder,.revokeOrder,.submitOrder :
            return .patch
        }
    }
    /// 请求参数
    var parameters:[String:Any]?{
        switch self {
        case .list(let params):
            return params
        case .submitOrder(_,let params):
            return params
        case .detail,.cancelOrder,.confirmOrder,.revokeOrder,.managers:
            return nil
        }
    }
    /// 请求参数的发送方式
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .list,.detail,.cancelOrder,.confirmOrder,.revokeOrder,.managers:
            return TokenURLEncoding.default
        case .submitOrder:
            return TokenJSONEncoding.default
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
