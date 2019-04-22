//
//  CompanyTravellerService.swift
//  shop
//
//  Created by manman on 2017/5/11.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import SwiftyJSON

/// 单例
final class HotelCompanyService {
    static let sharedInstance = HotelCompanyService()
    private init() {} // 阻止其他对象使用这个类的默认的'()'初始化方法
}

extension HotelCompanyService:Validator{
    
    /// 查询旅客列表
    ///
    /// - Parameter form: 查询条件
    /// - Returns: 查询结果
    func getTravellerList(uid: String) ->Observable<[Traveller]>{
        let provider = RxMoyaProvider<CompanyTravellerRouter>()
       return provider.request(.search(uid:uid))
                .debugHttp(true)
                .validateJustReturn(to: [Traveller.self])
    }
    
    /// 查询旅客列表分野
    ///
    /// - Parameters:
    ///   - qname: 查询人民
    ///   - pageSize: 一页多少条
    ///   - pageIndex: 页数
    /// - Returns: 查询结果
    func getPageTravellerList(qname: String,pageSize: Int,pageIndex: Int) ->Observable<[Traveller]>{
        let provider = RxMoyaProvider<CompanyTravellerRouter>()
        return provider.request(.searchPage(qname: qname, pageSize: pageSize, pageIndex: pageIndex))
            .debugHttp(true)
            .validateJustReturn(to: [Traveller.self])
    }
    
    /// 根据查询旅客列表
    ///
    /// - Parameter form: 查询条件
    /// - Returns: 查询结果
    func getTravellersBy(_ uids: [String]) ->Observable<[Traveller]>{
        let provider = RxMoyaProvider<CompanyTravellerRouter>()
        let uids = uids.joined(separator: ",")
        return provider.request(.searchDetailsBy(uids:uids))
            .debugHttp(true)
            .validateJustReturn(to: [Traveller.self])
    }
    
    /// 获取分公司列表
    ///
    /// - Parameter cityName:
    /// - Returns: 
    func subsidiaryList(cityName:String) ->Observable<[HotelSubsidiary]> {
        
        let provider = RxMoyaProvider<CompanyTravellerRouter>()
        return provider.request(.subsidiaryList(cityName: cityName))
            .debugHttp(true)
            .validateJustReturn(to: [HotelSubsidiary.self])
    }
    
    /// 获取企业酒店列表
    ///
    /// - Parameter searchCondition:
    /// - Returns:
    func getHotelsList(searchCondition:HotelSearchForm) ->Observable<[HotelCompanyListItem]>   {
        let provider = RxMoyaProvider<CompanyTravellerRouter>()
        return provider.request(.searchHotelList(parameters: searchCondition.toDict()))
            .debugHttp(true)
            .validateJustReturn(to: [HotelCompanyListItem.self])
    }
    
    /// 获取企业酒店详情
    ///
    /// - Parameter form: 查询条件
    /// - Returns: 查询结果
    func getDetail(_ form:HotelDetailForm) -> Observable<OHotel>{
        let provider = RxMoyaProvider<CompanyTravellerRouter>()
        return provider
            .request(.detail(id: form.hotelId, parameters: ["arrivalDate":form.arrivalDate,"departureDate":form.departureDate]))
            .debugHttp(true)
            .validateJustReturn(to: OHotel.self)
        
    }
    
    ///企业酒店下订单
    ///
    /// - Parameter order:
    func commit(order:HotelOrderInfo) -> Observable<String>{
        let provider = RxMoyaProvider<CompanyTravellerRouter>()
        return provider
            .request(.commit(parameters: order.toDict()))
            .debugHttp(true)
            .validateResponse().map{$0["orderNo"].stringValue}
        
    }
    
    
    ///计算担保金额
    func caculateGuaranteeAmount(parameter:Dictionary<String,Any>) ->Observable<String> {
        let provider = RxMoyaProvider<CompanyTravellerRouter>()
        return provider.request(.guaranteeCompany(parameters: parameter))
            .debugHttp(true)
            .validateResponse()
            .map{($0.stringValue)}
    }
    
    //获得公司个性化配置
    func companyConfig() ->Observable<HotelOrderInfo.CompanyCustomConfig>
    {
        let provider = RxMoyaProvider<CompanyTravellerRouter>()
        return provider.request(.companyConfig())
        .debugHttp(true)
        .validateJustReturn(to: HotelOrderInfo.CompanyCustomConfig.self)
    }
    
    
    
}

