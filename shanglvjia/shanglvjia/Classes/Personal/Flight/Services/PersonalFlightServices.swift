//
//  PersonalFlightServices.swift
//  shanglvjia
//
//  Created by manman on 2018/7/30.
//  Copyright © 2018年 TBI. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON
import Moya

/// 单例
final class PersonalFlightServices {
    static let sharedInstance = PersonalFlightServices()
    private init() {} // 阻止其他对象使用这个类的默认的'()'初始化方法
}
extension  PersonalFlightServices: Validator{
    /// 查询航班
    ///
    /// - Parameter form: 查询条件
    /// - Returns: 机票信息
    func searchPersonalFlightList(request:FlightSVSearchConditionModel) ->Observable<PCommonFlightSVSearchModel>{
        let provider = RxMoyaProvider<PersonalFlightRouter>()
        return provider
            .request(.personalFlightlList(request.mj_keyValues() as! [String : Any]))
            .debugHttp(true)
            .validateJustReturn(to: PCommonFlightSVSearchModel.self)
    }
    
    ///定投机票列表
    func sepcialPersonalFlightList(request:[String:Any])->Observable<PSpecialFlightListModel>{
        let provider = RxMoyaProvider<PersonalFlightRouter>()
        return provider
            .request(.sepcialPersonalFlightList(parameters: request))
            .debugHttp(true)
            .validateJustReturn(to: PSpecialFlightListModel.self)
    }
    
    
    /// 定投机票 列表信息
    func personalSpecialFlightInfoList(request:[String:Any])->Observable<PersonalSpecialFlightInfoListResponse> {
        let provider = RxMoyaProvider<PersonalFlightRouter>()
        return provider
            .request(.personalSpecialFlightInfoList(request))
            .debugHttp(true)
            .validateJustReturn(to: PersonalSpecialFlightInfoListResponse.self)
    }
    
    /// 定投机票 返程 列表信息
    func personalSpecialReturnFlightInfoList(request:[String:Any])->Observable<PersonalSpecialFlightInfoListResponse> {
        let provider = RxMoyaProvider<PersonalFlightRouter>()
        return provider
            .request(.personalSpecialReturnFlightInfo(request))
            .debugHttp(true)
            .validateJustReturn(to: PersonalSpecialFlightInfoListResponse.self)
    }
    
    
    ///定投机票仓位信息
    func sepcialPersonalFlightCabinList(request:[String:Any])->Observable<PSepcailFlightCabinModel>{
        let provider = RxMoyaProvider<PersonalFlightRouter>()
        return provider
            .request(.sepcialPersonalFlightCabinList(parameters: request))
            .debugHttp(true)
            .validateJustReturn(to: PSepcailFlightCabinModel.self)
    }
    ///特惠机票列表
    func onsalePersonalFlightCabinList(request:[String:Any])->Observable<PCommonFlightSVSearchModel>{
        let provider = RxMoyaProvider<PersonalFlightRouter>()
        return provider
            .request(.onsalePersonalFlightInfoList(parameters: request))
            .debugHttp(true)
            .validateJustReturn(to: PCommonFlightSVSearchModel.self)
    }
    
    ///特惠机票列表
    func onsalePersonalFlightCabinInfo(request:[String:Any])->Observable<PCommonFlightSVSearchModel>{
        let provider = RxMoyaProvider<PersonalFlightRouter>()
        return provider
            .request(.onsalePersonalFlightCabinInfo(request))
            .debugHttp(true)
            .validateJustReturn(to: PCommonFlightSVSearchModel.self)
    }
    
    func rebookCommonFlight(request:PersonalFlightReorderRequireRequest) ->Observable<Bool> {
        let provider = RxMoyaProvider<PersonalFlightRouter>()
        return provider
            .request(.rebookCommonFlightOrder(request.mj_keyValues() as! [String : Any]))
            .debugHttp(true)
            .validateResponse()
            .map({ (jsonData) -> Bool in
                return jsonData["status"].stringValue  == "0" ? true : false
            })
    }
    
    
    
    func personalFlightSubmitOrder(request:PersonalFlightRequestModel) -> Observable<PersonalSubmitFlightOrderResponse> {
        let provider = RxMoyaProvider<PersonalFlightRouter>()
        return provider
            .request(.personalFlightSubmitOrder(request.mj_keyValues() as! [String : Any]))
            .debugHttp(true)
            .validateJustReturn(to: PersonalSubmitFlightOrderResponse.self)
    }
    
    

}
