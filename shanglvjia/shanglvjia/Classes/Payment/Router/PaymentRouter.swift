//
//  PaymentRouter.swift
//  shop
//
//  Created by manman on 2017/7/10.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import Moya

//GET /api/v1/weixinpay/{orderNo}/fetchWeixinPayOrderInfo
//GET /api/v1aqawsasaqwaqwqwqwqwsqa a   qa  qa  q/alipay/{orderNo}/fetchAlipayOrderInfo
//GET /api/v1/orders/{orderNo}/time_remaining
enum PaymentRouter{
    case alipayOrderInfo(order:String)
    case weixinPayOrderInfo(order:String)
    case orderInfo(order:String)
    
    // 新版
    case personalWeixinPayOrderInfo(order:String) //GET /api/v1/weixinpay/{orderNo}/fetchWeixinPayOrderInfo
    case personalAliPayPayOrderInfo(order:String)//GET /api/v1/alipay/{orderNo}/fetchAlipayOrderInfo
    
    
    
}
extension PaymentRouter : TargetType {
    /// 请求的基础路径
    var baseURL:URL {return URL(string: "\(BASE_URL)")!}
    /// 拼接路径
    var path:String{
        switch self {
        case .alipayOrderInfo(let order):
            return "/alipay/\(order)/fetchAlipayOrderInfo"
        case .weixinPayOrderInfo(let order):
            return "weixinpay/\(order)/fetchWeixinPayOrderInfo"
        case .orderInfo(let order):
            return "orders/\(order)/time_remaining"
            
            // 新版
        case .personalWeixinPayOrderInfo(let order):
            return "tbi-cus-order-api/api/v1/weixinpay/\(order)/fetchWeixinPayOrderInfo"
        case .personalAliPayPayOrderInfo(let order):
            return "tbi-cus-order-api/api/v1/alipay/\(order)/fetchAlipayOrderInfo"
            
        }
    }
    /// 请求方法
    var method:Moya.Method{
        switch self {
        case .alipayOrderInfo,.weixinPayOrderInfo,.orderInfo,
             .personalWeixinPayOrderInfo,.personalAliPayPayOrderInfo:
            return .get
       
        }
    }
    /// 请求参数
    var parameters:[String:Any]?{
        switch self {
        case .alipayOrderInfo,.weixinPayOrderInfo,
             .orderInfo,.personalWeixinPayOrderInfo,
             .personalAliPayPayOrderInfo:
            return nil
        }
    }
    /// 请求参数的发送方式
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .alipayOrderInfo,.weixinPayOrderInfo,
             .orderInfo,.personalWeixinPayOrderInfo,
             .personalAliPayPayOrderInfo:
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
