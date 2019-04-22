//
//  CoNewFlightService.swift
//  shop
//
//  Created by akrio on 2017/5/19.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import RxSwift
import Moya

/// 单例
final class CoNewFlightService {
    static let sharedInstance = CoNewFlightService()
    private init() {} // 阻止其他对象使用这个类的默认的'()'初始化方法
}

// MARK: - 企业新版机票相关service
extension  CoNewFlightService: Validator{
    /// 查询航班
    ///
    /// - Parameter form: 查询条件
    /// - Returns: 机票信息
    func search(_ form:CoFlightForm.Search) -> Observable<CoFlightSearchResult> {
        let provider = RxMoyaProvider<CoNewFlightsRouter>()
        return provider
            .request(.list(form.toDict()))
            .debugHttp(true)
            .validateJustReturn(to: CoFlightSearchResult.self)
    }
    /// 创建订单
    ///
    /// - Parameter form: 创建表单
    /// - Returns: 机票信息
    func create(_ form:CoNewFlightForm.Create) -> Observable<String> {
        let provider = RxMoyaProvider<CoNewFlightsRouter>()
        //验证手机号填写是否正确
        guard form.linkmanMobile.value.validate(.phone) else {
            return validateMessageObservable("common.validate.phone.message")
        }
        guard form.linkmanName.value.isNotEmpty else {
            return validateMessageObservable("common.validate.isempty.message","联系人姓名")
        }
        
        return provider
            .request(.commit(form.toDict()))
            .debugHttp(true)
            .validateResponse()
            .map{ $0["orderNo"].stringValue }
    }
}
