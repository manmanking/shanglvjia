//
//  FlightService.swift
//  shop
//
//  Created by akrio on 2017/4/24.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import RxSwift
import Moya

/// 单例
final class FlightService {
    static let sharedInstance = FlightService()
    private init() {} // 阻止其他对象使用这个类的默认的'()'初始化方法
}

// MARK: - 机票相关service
extension  FlightService: Validator{
    
    
    
    /// 查询航班
    ///
    /// - Parameter form: 查询条件
    /// - Returns: 机票信息
    func search(_ form:FlightSearchForm) -> Observable<FlightSearchResult> {
        let provider = RxMoyaProvider<FlightsRouter>()
        return provider
            .request(.list(form.toDict()))
            .debugHttp(true)
            .validateJustReturn(to: FlightSearchResult.self)
    }
    /// 生成订单
    ///
    /// - Parameter form: 表单
    /// - Returns: 订单号
    func commit(_ form:FlightCommitForm) -> Observable<String> {
        print(form.toDict())
        if form.passengers.isEmpty {
            return validateMessageObservable("common.validate.isempty.message","乘机人")
        }
        for index in 0..<form.passengers.count{
            guard form.passengers[index].name.isNotEmpty else {
                return validateMessageObservable("common.validate.isempty.message","乘机人姓名")
            }
            guard form.passengers[index].cardNo.isNotEmpty else {
                return validateMessageObservable("common.validate.isempty.message","乘机人证件号")
            }
            guard form.passengers[index].phone.validate(.phone) else {
                return validateMessageObservable("common.validate.phone.message")
            }
            if  form.passengers[index].cardType == "0"{//如果是身份证校验下格式
                guard form.passengers[index].cardNo.validate(.card) else {
                    return validateMessageObservable("common.validate.card.message")
                }
            }
            
        }
        //验证手机号填写是否正确
        guard form.orderContact.contactPhone.value.validate(.phone) else {
            return validateMessageObservable("common.validate.phone.message")
        }
        guard form.orderContact.contactName.value.isNotEmpty else {
             return validateMessageObservable("common.validate.isempty.message","联系人姓名")
        }
        if form.orderInvoice != nil  {
            guard form.orderInvoice?.name.value.isNotEmpty ?? false else {
                return validateMessageObservable("common.validate.isempty.message","收件人姓名")
            }
            guard form.orderInvoice?.address.value.isNotEmpty ?? false else {
                 return validateMessageObservable("common.validate.isempty.message","详细地址")
            }
            guard form.orderInvoice?.tel.value.validate(.phone) ?? false else {
                return validateMessageObservable("common.validate.phone.message")
            }
        }
        
        let provider = RxMoyaProvider<FlightsRouter>()
        return provider
            .request(.commit(form.toDict()))
            .debugHttp(true)
            .validateResponse()
            .map{$0.stringValue}
    }
    
    //MARK:--------NEWOBT------------
    func searchFlightList(request:FlightSVSearchConditionModel) ->Observable<FlightSVSearchResultVOModel>{
        let provider = RxMoyaProvider<FlightsRouter>()
        return provider
            .request(.flightList(request.mj_keyValues() as! [String : Any]))
            .debugHttp(true)
            .validateJustReturn(to: FlightSVSearchResultVOModel.self)
    }

    
    /// 检查保险
    func checkInsurance(request:SuranceInfoParamVO)->Observable<SuranceInfoResultVO> {
        let provider = RxMoyaProvider<FlightsRouter>()
        return provider
            .request(.checkInsurance(request.mj_keyValues() as! [String : Any]))
            .debugHttp(true)
            .validateJustReturn(to: SuranceInfoResultVO.self)
    }
    
    //提交订单
    func commitOrder(request:CommitParamVOModel)->Observable<[String]> {
        let provider = RxMoyaProvider<FlightsRouter>()
        return provider
            .request(.commitOrder(request.mj_keyValues() as! [String : Any]))
            .debugHttp(true)
            .validateResponse()
            .map({ (json) -> [String] in
                return json["orderIds"].arrayValue.map{$0.stringValue}
            })
    }
    
    /// 获得推荐 航班信息
    func getrightFlightList(request:RecommendRightFlightVOModel)->Observable<[RecommendFlightResultVOModel]>{
        let provider = RxMoyaProvider<FlightsRouter>()
        return provider
            .request(.rightFlight(request.mj_keyValues() as! [String : Any]))
            .debugHttp(true)
            .validateJustReturn(to: [RecommendFlightResultVOModel.self])
    }
    
    
}

