//
//  PersonalTravelServices.swift
//  shanglvjia
//
//  Created by manman on 2018/7/30.
//  Copyright © 2018年 TBI. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON
import RxSwift


final class PersonalTravelServices {
    static let sharedInstance = PersonalTravelServices()
    private init() {}
}
// MARK: - 旅游相关service
extension  PersonalTravelServices: Validator{


    func personalTravelList(request:PTravelProductListRequest)->Observable<PTravelProductListResponse> {
        
        let provider = RxMoyaProvider<PersonalTravelRouter>()
        return provider
            .request(.personalTravelList(request.mj_keyValues() as! [String : Any]))
            .debugHttp(true)
            .validateJustReturn(to: PTravelProductListResponse.self)
    }
    
    ///自由行详情
    func personalTravelDetail(id:String) -> Observable<PTravelIndependentDetailModel>{
        let provider = RxMoyaProvider<PersonalTravelRouter>()
        return provider
            .request(.personalTravelDetail(id:id))
            .debugHttp(true)
            .validateJustReturn(to: PTravelIndependentDetailModel.self)
    }
    ///周边游详情
    func personalNearbyDetail(id:String) -> Observable<PTravelNearbyDetailModel>{
        let provider = RxMoyaProvider<PersonalTravelRouter>()
        return provider
            .request(.personalNearbyDetail(id:id))
            .debugHttp(true)
            .validateJustReturn(to: PTravelNearbyDetailModel.self)
    }
    ///下单
    func personalTravelOrder(request:PTravelOrderAddRequest) -> Observable<PersonalSubmitHotelOrderResponse> {
        let provider = RxMoyaProvider<PersonalTravelRouter>()
        return provider
            .request(.personalTravelOrder(request.mj_keyValues() as! [String : Any]))
            .debugHttp(true)
            .validateJustReturn(to: PersonalSubmitHotelOrderResponse.self)
    }
    
    ///周边游详情
    func personalTopicDetail(id:String) -> Observable<[PersonalTopicModel]>{
        let provider = RxMoyaProvider<PersonalTravelRouter>()
        return provider
            .request(.personalTopicDetail(id:id))
            .debugHttp(true)
            .validateJustReturn(to: [PersonalTopicModel.self])
    }
    
}


