//
//  CoOldExanimeService.swift
//  shop
//
//  Created by akrio on 2017/5/27.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import RxSwift
import Moya

/// 单例
final class CoOldExanimeService {
    static let sharedInstance = CoOldExanimeService()
    private init() {} // 阻止其他对象使用这个类的默认的'()'初始化方法
}

// MARK: - 企业老版审批service
extension  CoOldExanimeService: Validator{
    /// 查询订单列表
    ///
    /// - Parameter form: 查询条件
    /// - Returns: 机票信息
    func search(_ form:CoOldExanimeForm.SearchList) -> Observable<[CoOldExanimeListItem]> {
        let provider = RxMoyaProvider<CoOldExamineRouter>()
        return provider
            .request(.list(form.toDict()))
            .debugHttp(true)
            .validateResponse()
            .map{ json in
                let json = json["orders"]
                return json.arrayValue.flatMap{CoOldExanimeListItem(jsonData:$0)}
        }
    }
    /// 同意订单
    ///
    /// - Parameters:
    ///   - orderNo: 出差单号
    ///   - form: 审批相关数据
    /// - Returns: 审批后订单详情
    func agree(_ orderNo:String,form:CoOldExanimeForm.Agree) ->  Observable<CoOldOrderDetail>{
        var form = form
        let provider = RxMoyaProvider<CoOldExamineRouter>()
        return getNextApvId(orderNo).map{ apvId  ->  Observable<CoOldOrderDetail> in
            form.nextApverId = apvId
            return provider
                .request(.agree(orderNo, form.toDict()))
                .debugHttp()
                .validateJustReturn(to: CoOldOrderDetail.self)
            }.concat()
    }
    /// 拒绝订单
    ///
    /// - Parameters:
    ///   - orderNo: 出差单号
    ///   - form: 审批相关数据
    /// - Returns: 审批后订单详情
    func agree(_ orderNo:String,form:CoOldExanimeForm.Reject) ->  Observable<CoOldOrderDetail>{
        let provider = RxMoyaProvider<CoOldExamineRouter>()
        return provider
            .request(.reject(orderNo, form.toDict()))
            .debugHttp()
            .validateJustReturn(to: CoOldOrderDetail.self)
    }
    /// 获取下级审批人Id
    ///
    /// - Parameter orderNo: 订单号
    /// - Returns: 下级审批人id
    func getNextApvId(_ orderNo:String) -> Observable<String> {
        let provider = RxMoyaProvider<CoOldExamineRouter>()
        return provider
            .request(.nextApver(orderNo))
            .debugHttp()
            .validateResponse()
            .map{ $0.stringValue }
        
    }
}
