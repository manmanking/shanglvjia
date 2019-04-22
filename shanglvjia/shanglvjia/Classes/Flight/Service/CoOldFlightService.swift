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
final class CoOldFlightService {
    static let sharedInstance = CoOldFlightService()
    private init() {} // 阻止其他对象使用这个类的默认的'()'初始化方法
}

// MARK: - 企业老版机票相关service
extension  CoOldFlightService: Validator{
    /// 查询航班
    ///
    /// - Parameter form: 查询条件
    /// - Returns: 机票信息
    func search(_ form:CoFlightForm.Search) -> Observable<CoFlightSearchResult> {
        let provider = RxMoyaProvider<CoOldFlightsRouter>()
        return provider
            .request(.list(form.toDict()))
            .debugHttp(true)
            .validateJustReturn(to: CoFlightSearchResult.self)
    }
    /// 创建机票订单
    ///
    /// - Parameter form: 订单信息
    /// - Returns: 订单号
    func create(_ form:CoOldFlightForm.Create) -> Observable<String> {
        let provider = RxMoyaProvider<CoOldFlightsRouter>()
        for index in 0..<(form.passangers?.count ?? 0){
            if (form.passangers?[index].certType ?? nil) == nil {
                return validateMessageObservable("common.validate.isempty.message","乘机人证件类型")
            }
            if form.passangers?[index].certNo.isEmpty ?? true {
                return validateMessageObservable("common.validate.isempty.message","乘机人证件号")
            }
            if form.passangers?[index].mobile.isEmpty ?? true {
                return validateMessageObservable("common.validate.isempty.message","乘机人手机号")
            }
            if form.passangers?[index].certType == 1 {
                if !(form.passangers?[index].certNo.validate(.card))! {
                    return validateMessageObservable("common.validate.card.message")
                }
            }
            if (form.passangers?[index].rtnInsurance ?? false) || (form.passangers?[index].depInsurance ?? false){//如果购买保险生日不能为空
                if form.passangers?[index].birthday.isEmpty ?? true{
                    return validateMessageObservable("common.validate.isempty.message","受保人生日")
                }
                
            }
        }
        
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
