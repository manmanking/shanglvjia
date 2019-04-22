//
//  JourneyService.swift
//  shop
//
//  Created by TBI on 2017/6/15.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import SwiftyJSON
/// 单例
final class CompanyJourneyService {
    static let sharedInstance = CompanyJourneyService()
    private init() {} // 阻止其他对象使用这个类的默认的'()'初始化方法
}

extension CompanyJourneyService: Validator {
    
    /// 获取行程列表
    func getList(_ form:JourneySearchForm) -> Observable<[CompanyJourneyResult]>{
        let provider = RxMoyaProvider<CompanyJourneysRouter>()
        return provider
            .request(.list(form.toDict()))
            .debugHttp(true)
            .validateJustReturn(to: [CompanyJourneyResult.self])
        
    }
    
    /// 获取行程count
    func getCount() -> Observable<CompanyJourneyCountResult>{
        let provider = RxMoyaProvider<CompanyJourneysRouter>()
        return provider
            .request(.count())
            .debugHttp(true)
            .validateJustReturn(to: CompanyJourneyCountResult.self)
        
    }
    
    func getFlightList(_ form:JourneySearchForm) -> Observable<[CompanyJourneyResult]>{
        let provider = RxMoyaProvider<CompanyJourneysRouter>()
        return provider
            .request(.flightList(form.toDict()))
            .debugHttp(true)
            .validateJustReturn(to: [CompanyJourneyResult.self])
        
    }
    
    //-------NEWOBT-------
    
    func getPersonalFlightList(pageNo:NSInteger)->Observable<PersonalFlightListResponse> {
        let request:Dictionary<String, Any> = ["pageNo":pageNo]
        let provider = RxMoyaProvider<CompanyJourneysRouter>()
        return provider
            .request(.personalFlightList(request))
            .debugHttp(true)
            .validateJustReturn(to:PersonalFlightListResponse.self)
    }
    
    
    
    
    
}
