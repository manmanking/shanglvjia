//
//  MyTripService.swift
//  shop
//
//  Created by zhanghao on 2017/7/12.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import SwiftyJSON

/// 单例
final class MyTirpService {
    static let sharedInstance = MyTirpService()
    private init() {} // 阻止其他对象使用这个类的默认的'()'初始化方法
}

extension MyTirpService: Validator {
    func getMyTirp() -> Observable<[MyTripListResponse]> {
        let provider = RxMoyaProvider<MyTripRouter>()
        return provider
            .request(.myTrip)
            .debugHttp(true)
            .validateJustReturn(to: [MyTripListResponse.self])
    }
    
    
    /// 获得行程
    func getUserTrip(pageNo:String)->Observable<PersonalJourneyListResponse> {
        let request:[String:Any] = ["pageNo":pageNo]
        let provider = RxMoyaProvider<MyTripRouter>()
        return provider
            .request(.trip(request))
            .debugHttp(true)
            .validateJustReturn(to: PersonalJourneyListResponse.self)
    }
    
    
}
