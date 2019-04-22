//
//  PaymentService.swift
//  shop
//
//  Created by manman on 2017/7/10.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import RxSwift
import Moya
/// 单例
final class PaymentService {
    static let sharedInstance = PaymentService()
    private init() {} // 阻止其他对象使用这个类的默认的'()'初始化方法
}

extension  PaymentService: Validator{
    
    /// 获取订单 信息
    ///
    /// - Parameter form: 查询条件
    /// - Returns: 查询结果
    func orderInfo(order:String) -> Observable<OrderVO>{
        let provider = RxMoyaProvider<PaymentRouter>()
        return provider
            .request(.orderInfo(order:order))
            .debugHttp(true)
            .validateJustReturn(to: OrderVO.self)
    }
    
    
    
    
    
    

    /// 获取阿里支付 信息
    ///
    /// - Parameter form: 查询条件
    /// - Returns: 查询结果
    func alipayOrderInfo(order:String) -> Observable<String>{
        let provider = RxMoyaProvider<PaymentRouter>()
        return provider
            .request(.alipayOrderInfo(order:order))
            .debugHttp(true)
            .validateResponse()
            .map{($0.stringValue)}
    }
    /// 获取微信支付 信息
    ///
    /// - Parameter form: 查询条件
    /// - Returns: 查询结果
    func wechatOrderInfo(order:String) -> Observable<String>{
        let provider = RxMoyaProvider<PaymentRouter>()
        return provider
            .request(.weixinPayOrderInfo(order:order))
            .debugHttp(true)
            .validateResponse()
            .map{($0.stringValue)}
    }
    
    //MARK:-----新版-----
    
    /// 微信支付
    func wechatPersonalOrderInfo(order:String) -> Observable<String>{
        let provider = RxMoyaProvider<PaymentRouter>()
        return provider
            .request(.personalWeixinPayOrderInfo(order:order))
            .debugHttp(true)
            .validateResponse()
            .map{($0.stringValue)}
    }
    
    func alipayPersonalOrderInfo(order:String) -> Observable<String> {
        let provider = RxMoyaProvider<PaymentRouter>()
        return provider
            .request(.personalAliPayPayOrderInfo(order:order))
            .debugHttp(true)
            .validateResponse()
            .map{($0.stringValue)}
    }
    
    
    
}

 
