//
//  CoOldOrderService.swift
//  shop
//
//  Created by akrio on 2017/5/15.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import RxSwift
import Moya

/// 单例
final class CoOldOrderService {
    static let sharedInstance = CoOldOrderService()
    private init() {} // 阻止其他对象使用这个类的默认的'()'初始化方法
}

// MARK: - 企业老版订单service
extension  CoOldOrderService: Validator{
   
    /// 查询订单列表
    ///
    /// - Parameter form: 查询条件
    /// - Returns: 订单概要信息
    func searchList(_ form:CoOldOrderForm.ListSearch) -> Observable<[CoOldOrderListItem]> {
        let provider = RxMoyaProvider<CoOldOrdersRouter>()
        return provider
            .request(.list(form.toDict()))
            .debugHttp(true)
            .validateResponse()
            .map { json in  json["orders"].arrayValue.map { CoOldOrderListItem(jsonData: $0) } }
    }
    
    /// 查询订单详情
    ///
    /// - Parameter orderNo: 订单号
    /// - Returns: 订单详情
    func getDetailBy(_ orderNo:String) -> Observable<CoOldOrderDetail> {
        let provider = RxMoyaProvider<CoOldOrdersRouter>()
        //读取个人信息详情查看是否为oa送审

        return provider
            .request(.detail(orderNo))
            .debugHttp()
            .validateJustReturn(to: CoOldOrderDetail.self)
        
    }
    /// 撤销订单
    ///
    /// - Parameter orderNo: 撤销的订单号
    /// - Returns: 撤销订单后的订单详情
    func revokeBy(_ orderNo:String) -> Observable<CoOldOrderDetail> {
        let provider = RxMoyaProvider<CoOldOrdersRouter>()
        return provider
            .request(.revokeOrder(orderNo))
            .debugHttp()
            .validateJustReturn(to: CoOldOrderDetail.self)
    }
    /// 取消订单
    ///
    /// - Parameter orderNo: 取消的订单号
    /// - Returns: 取消订单后的订单详情
    func cancelBy(_ orderNo:String) -> Observable<CoOldOrderDetail> {
        let provider = RxMoyaProvider<CoOldOrdersRouter>()
        return provider
            .request(.cancelOrder(orderNo))
            .debugHttp()
            .validateJustReturn(to: CoOldOrderDetail.self)
    }
    /// 订单转为待订妥
    ///
    /// - Parameter orderNo: 订单转为待订妥的订单号
    /// - Returns: 待订妥后的订单详情
    func confirmBy(_ orderNo:String) -> Observable<CoOldOrderDetail> {
        let provider = RxMoyaProvider<CoOldOrdersRouter>()
        return provider
            .request(.confirmOrder(orderNo))
            .debugHttp()
            .validateJustReturn(to: CoOldOrderDetail.self)
    }
    /// 获取订单审批人信息
    ///
    /// - Parameter orderNo: 订单号
    /// - Returns: 每个级别的审批人信息
    func getManagers(_ orderNo:String) -> Observable<[(key:Int,value:[CoManagerListItem])]> {
        let provider = RxMoyaProvider<CoOldOrdersRouter>()
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
    /// 送审订单
    ///
    /// - Parameter form: 送审订单
    /// - Returns: 订单详情
    func submitOrder(_ orderNo:String,_ form:CoOldOrderForm.Submit? = nil) -> Observable<CoOldOrderDetail> {
        let provider = RxMoyaProvider<CoOldOrdersRouter>()
        return provider
            .request(.submitOrder(orderNo, form?.toDict()))
            .debugHttp()
            .validateJustReturn(to: CoOldOrderDetail.self)
    }
    /// 无需送审订单
    ///
    /// - Parameter orderNo: 送审单号
    /// - Returns: 订单详情
    func noSubmitOrder(_ orderNo:String) -> Observable<CoOldOrderDetail> {
        let provider = RxMoyaProvider<CoOldOrdersRouter>()
        return provider
            .request(.submitOrder(orderNo,[:]))
            .debugHttp()
            .validateJustReturn(to: CoOldOrderDetail.self)
    }
}
