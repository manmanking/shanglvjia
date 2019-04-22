//
//  NewOrdersRouter.swift
//  shop
//
//  Created by akrio on 2017/5/15.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import Moya

/// 企业新版订单相关router
///
/// - list: 出差单列表
/// - detail: 出差单详情
/// - create: 创建出差单
/// - modify: 修改出差单
/// - customConfig: 获取出差单自定义字段
/// - cancelOrder: 将订单状态变为取消
/// - confirmOrder: 订单转为待定妥
/// - revokeOrder: 订单撤销送审
/// - submitOrder: 订单送审|无需送审
/// - managers: 获取订单审批人信息
/// - delSmallOrderFlight: 删除机票小订单
/// - delSmallOrderHotel: 删除酒店小订单
enum CoNewOrdersRouter {
    case list([String:Any])
    case detail(String)
    case create([String:Any])
    case modify(String,[String:Any])
    case customConfig()
    case cancelOrder(String)
    case confirmOrder(String)
    case revokeOrder(String)
    case submitOrder(String,[String:Any])
    case managers(String)
    case delSmallOrderFlight(String,String)
    case delSmallOrderHotel(String,String)
    case delSmallOrderTrain(String,String)
    case delSmallOrderCar(String,String)
}
extension CoNewOrdersRouter:TargetType{
    /// 请求的基础路径
    var baseURL:URL {return URL(string: "\(BASE_URL)/company/new_orders")!}
    /// 拼接路径
    var path:String{
        switch self {
        case .list:
            return "/lite"
        case .create:
            return "/"
        case .customConfig:
            return "/configs"
        case .detail(let id),.modify(let id,_):
            return "/\(id)"
        case .cancelOrder(let id):
            return "/\(id)/cancel"
        case .confirmOrder(let id):
            return "/\(id)/confirm"
        case .revokeOrder(let id):
            return "/\(id)/revoke"
        case .submitOrder(let id,_):
            return "/\(id)/submit"
        case .managers(let id):
            return "/\(id)/managers"
        case .delSmallOrderFlight(let orderNo, let flightOrderNo):
            return "/\(orderNo)/flights/\(flightOrderNo)/cancel"
        case .delSmallOrderHotel(let orderNo, let hotelOrderNo):
            return "/\(orderNo)/hotels/\(hotelOrderNo)/cancel"
        case .delSmallOrderTrain(let orderNo, let trainOrderNo):
            return "/\(orderNo)/trains/\(trainOrderNo)/cancel"
        case .delSmallOrderCar(let orderNo, let carOrderNo):
            return "/\(orderNo)/cars/\(carOrderNo)/cancel"
        }
    }
    /// 请求方法
    var method:Moya.Method{
        switch self {
        case .list,.detail,.customConfig,.managers:
            return .get
        case .create:
            return .post
        case .modify:
            return .put
        case .cancelOrder,.confirmOrder,.revokeOrder,.submitOrder,.delSmallOrderFlight,.delSmallOrderHotel,.delSmallOrderTrain,.delSmallOrderCar:
            return .patch
        }
    }
    /// 请求参数
    var parameters:[String:Any]?{
        switch self {
        case .list(let params),.create(let params),.modify(_,let params),.submitOrder(_, let params):
            return params
        case .detail,.customConfig,.cancelOrder,.confirmOrder,.revokeOrder,.managers,.delSmallOrderFlight,.delSmallOrderHotel,.delSmallOrderCar,.delSmallOrderTrain:
            return nil
        }
    }
    /// 请求参数的发送方式
    var parameterEncoding: ParameterEncoding {
        switch self {
    case .list,.detail,.customConfig,.cancelOrder,.confirmOrder,.revokeOrder,.managers,.delSmallOrderFlight,.delSmallOrderHotel,.delSmallOrderCar,.delSmallOrderTrain:
            return TokenURLEncoding.default
        case .create,.modify,.submitOrder:
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
