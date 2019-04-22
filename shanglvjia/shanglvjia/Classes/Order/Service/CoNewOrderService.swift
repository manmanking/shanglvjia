//
//  CoNewOrderService.swift
//  shop
//
//  Created by akrio on 2017/5/15.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import RxSwift
import Moya

/// 单例
final class CoNewOrderService {
    static let sharedInstance = CoNewOrderService()
    private init() {} // 阻止其他对象使用这个类的默认的'()'初始化方法
}

// MARK: - 企业版新版订单service
extension  CoNewOrderService: Validator{
    /// 查询订单
    ///
    /// - Parameter form: 查询条件
    /// - Returns: 机票信息
    func search(_ form:CoNewOrderSearchFrom) -> Observable<[CoNewOrderListItem]> {
        let provider = RxMoyaProvider<CoNewOrdersRouter>()
        return provider
            .request(.list(form.toDict()))
            .debugHttp(true)
            .validateResponse()
            .map{ json in
                let json = json["orders"]
                return json.arrayValue.flatMap{CoNewOrderListItem(jsonData:$0)}
            }
    }
    /// 创建出差单
    ///
    /// - Parameter form: 表单实体
    /// - Returns: 出差单详情
    func create(_ form:ModifyAndCreateCoNewOrderFrom) -> Observable<CoNewOrderDetail> {
        
        guard form.reason.value.characters.count < 13 else{
            return validateMessageObservable("common.validate.islength.message","出差原因")
        }
        guard (form.destinations.first?.value.characters.count ?? 0) < 25 else{
            return validateMessageObservable("common.validate.islength.message","出差地点")
        }
        
        let provider = RxMoyaProvider<CoNewOrdersRouter>()
        return provider
            .request(.create(form.toDict()))
            .debugHttp(true)
            .validateJustReturn(to: CoNewOrderDetail.self)
    }
    /// 修改出差单
    ///
    /// - Parameter form: 表单实体
    /// - Returns: 出差单详情
    func modify(_ orderNo:String,form:ModifyAndCreateCoNewOrderFrom) -> Observable<CoNewOrderDetail> {
        guard form.reason.value.characters.count < 13 else{
            return validateMessageObservable("common.validate.islength.message","出差原因")
        }
        guard (form.destinations.first?.value.characters.count ?? 0) < 25 else{
            return validateMessageObservable("common.validate.islength.message","出差地点")
        }
        
        let provider = RxMoyaProvider<CoNewOrdersRouter>()
        return provider
            .request(.modify(orderNo,form.toDict()))
            .debugHttp(true)
            .validateJustReturn(to: CoNewOrderDetail.self)
    }
    /// 查询订单详情
    ///
    /// - Parameter form: 查询条件
    /// - Returns: 机票信息
    func getDetailBy(_ orderNo:String) -> Observable<CoNewOrderDetail> {
        let provider = RxMoyaProvider<CoNewOrdersRouter>()
        return provider
            .request(.detail(orderNo))
            .debugHttp(true)
            .validateJustReturn(to: CoNewOrderDetail.self)
    }
    /// 获取出差单自定义字段
    ///
    /// - Returns: 自定义字段
    func getCustomConfigBy() -> Observable<CoNewOrderCustomConfig> {
        let provider = RxMoyaProvider<CoNewOrdersRouter>()
        return provider
            .request(.customConfig())
            .debugHttp(true)
            .validateJustReturn(to: CoNewOrderCustomConfig.self)
    }
    /// 撤销订单
    ///
    /// - Parameter orderNo: 撤销的订单号
    /// - Returns: 撤销订单后的订单详情
    func revokeBy(_ orderNo:String) -> Observable<CoNewOrderDetail> {
        let provider = RxMoyaProvider<CoNewOrdersRouter>()
        return provider
            .request(.revokeOrder(orderNo))
            .debugHttp()
            .validateJustReturn(to: CoNewOrderDetail.self)
    }
    /// 取消订单
    ///
    /// - Parameter orderNo: 取消的订单号
    /// - Returns: 取消订单后的订单详情
    func cancelBy(_ orderNo:String) -> Observable<CoNewOrderDetail> {
        let provider = RxMoyaProvider<CoNewOrdersRouter>()
        return provider
            .request(.cancelOrder(orderNo))
            .debugHttp()
            .validateJustReturn(to: CoNewOrderDetail.self)
    }
    /// 订单转为待订妥
    ///
    /// - Parameter orderNo: 订单转为待订妥的订单号
    /// - Returns: 待订妥后的订单详情
    func confirmBy(_ orderNo:String) -> Observable<CoNewOrderDetail> {
        let provider = RxMoyaProvider<CoNewOrdersRouter>()
        return provider
            .request(.confirmOrder(orderNo))
            .debugHttp()
            .validateJustReturn(to: CoNewOrderDetail.self)
    }
    /// 出差单送审
    ///
    /// - Parameters:
    ///   - orderNo: 出差单号
    ///   - apvIds: 审批人信息
    func submit(_ orderNo:String,apvIds:[String]? = nil) -> Observable<CoNewOrderDetail> {
        let provider = RxMoyaProvider<CoNewOrdersRouter>()
        let form = CoNewOrderSubmit(apverIds: apvIds)
        return provider
            .request(.submitOrder(orderNo, form.toDict()))
            .debugHttp(true)
            .validateJustReturn(to: CoNewOrderDetail.self)
    }
    /// 获取订单审批人信息
    ///
    /// - Parameter orderNo: 订单号
    /// - Returns: 每个级别的审批人信息
    func getManagers(_ orderNo:String) -> Observable<[(key:Int,value:[CoManagerListItem])]> {
        let provider = RxMoyaProvider<CoNewOrdersRouter>()
        return provider
            .request(.managers(orderNo))
            .debugHttp()
            .validateResponse()
            .map{ json in
                //根据审批级别对审批人进行分组
                return json.arrayValue.reduce([Int:[CoManagerListItem]]()){ i,e in
                    var i = i
                    let manager = CoManagerListItem(jsonData: e)
                    //判断是否已经包含当前审批级别,如果已经包含当前审批则将遍历的审批人添加到该审批级别中
                    guard i[e["apverLevel"].intValue] != nil else{
                        i[e["apverLevel"].intValue] = [manager]
                        return i
                    }
                    i[e["apverLevel"].intValue]?.append(manager)
                    return i
                }.sorted{ $0.key < $1.key }
        }
    }
    
    /// 取消机票小订单
    ///
    /// - Parameter 
    ///        orderNo: 订单号
    ///        flightOrderNo   机票订单号
    /// - Returns: CoNewOrderDetail   新版的订单
    func cancelFlightOrder(orderNo:String,flightOrderNo:String) -> Observable<CoNewOrderDetail>
    {
        let provider = RxMoyaProvider<CoNewOrdersRouter>()
        return provider
            .request(.delSmallOrderFlight(orderNo,flightOrderNo))
            .debugHttp(true)
            .validateJustReturn(to: CoNewOrderDetail.self)
    }
    
    /// 取消酒店小订单
    ///
    /// - Parameter
    ///        orderNo: 订单号
    ///        hotelOrderNo   酒店订单号
    /// - Returns: CoNewOrderDetail   新版的订单
    func cancelHotelOrder(orderNo:String,hotelOrderNo:String) -> Observable<CoNewOrderDetail>
    {
        let provider = RxMoyaProvider<CoNewOrdersRouter>()
        return provider
            .request(.delSmallOrderHotel(orderNo,hotelOrderNo))
            .debugHttp(true)
            .validateJustReturn(to: CoNewOrderDetail.self)
    }
    
    
    /// 取消火车订单
    ///
    /// - Parameters:
    ///   - orderNo: 订单号
    ///   - trainOrderNo: 火车订单号
    /// - Returns:
    func cancelTrainOrder(orderNo:String,trainOrderNo:String) -> Observable<CoNewOrderDetail>
    {
        let provider = RxMoyaProvider<CoNewOrdersRouter>()
        return provider
            .request(.delSmallOrderTrain(orderNo, trainOrderNo))
            .debugHttp(true)
            .validateJustReturn(to: CoNewOrderDetail.self)
    }
    
    
    /// 取消专车订单
    ///
    /// - Parameters:
    ///   - orderNo: 订单号
    ///   - carOrderNo: 专车订单号
    /// - Returns:
    func cancelCarOrder(orderNo:String,carOrderNo:String) -> Observable<CoNewOrderDetail>
    {
        let provider = RxMoyaProvider<CoNewOrdersRouter>()
        return provider
            .request(.delSmallOrderCar(orderNo, carOrderNo))
            .debugHttp(true)
            .validateJustReturn(to: CoNewOrderDetail.self)
    }
}




