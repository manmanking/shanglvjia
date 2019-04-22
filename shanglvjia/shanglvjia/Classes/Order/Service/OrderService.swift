//
//  OrderService.swift
//  shop
//
//  Created by akrio on 2017/5/12.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import SwiftyJSON

/// 单例
final class OrderService {
    static let sharedInstance = OrderService()
    private init() {} // 阻止其他对象使用这个类的默认的'()'初始化方法
}

// MARK: - 订单service
extension  OrderService: Validator{
    /// 查询订单
    ///
    /// - Parameter form: 查询条件
    /// - Returns: 机票信息
    func search(_ form:OrderSearchForm) -> Observable<[OrderListItem]> {
        let provider = RxMoyaProvider<OrdersRouter>()
        return provider
            .request(.list(form.toDict()))
            .debugHttp(true)
            .validateJustReturn(to: [OrderListItem.self])
    }
    /// 查询机票订单详情
    ///
    /// - Parameter form: 查询条件
    /// - Returns: 机票信息
    func flightDetailBy(_ orderNo:String) -> Observable<FlightOrderDetail> {
        let provider = RxMoyaProvider<OrdersRouter>()
        return provider
            .request(.flight(orderNo: orderNo))
            .debugHttp(true)
            .validateJustReturn(to: FlightOrderDetail.self)
    }
    /// 查询酒店订单详情
    ///
    /// - Parameter form: 查询条件
    /// - Returns: 酒店信息
    func hotelDetailBy(_ orderNo:String) -> Observable<HotelOrderDetail> {
        let provider = RxMoyaProvider<OrdersRouter>()
        return provider
            .request(.hotel(orderNo: orderNo))
            .debugHttp(true)
            .validateJustReturn(to: HotelOrderDetail.self)
    }
    
    /// 查询旅游订单详情
    ///
    /// - Parameter form: 查询条件
    /// - Returns: 旅游信息
    func travelOrderDetailBy(orderNo:String) -> Observable<PSpecialOrderDetails> {
        let provider = RxMoyaProvider<OrdersRouter>()
        return provider
            .request(.travelOrderDetails(orderNo: orderNo))
            .debugHttp(true)
            .validateJustReturn(to: PSpecialOrderDetails.self)
    }
    
    /// 取消订单   
    ///
    /// - Parameter form: 查询条件
    /// - Returns: 旅游信息
    func cancelOrder(orderNo:String) -> Observable<String> {
        let provider = RxMoyaProvider<OrdersRouter>()
        return provider
            .request(.cancelOrder(orderNo: orderNo))
            .debugHttp(true)
            .validateResponse()
            .map{return $0.description}
    }
    
    
    
    
    
}
