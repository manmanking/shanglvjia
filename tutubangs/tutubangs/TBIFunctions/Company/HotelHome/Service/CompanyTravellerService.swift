//
//  CompanyTravellerService.swift
//  shop
//
//  Created by manman on 2017/5/11.
//  Copyright © 2017年 zhangwangwang. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import SwiftyJSON

/// 单例
final class CompanyTravellerService {
    static let sharedInstance = CompanyTravellerService()
    private init() {} // 阻止其他对象使用这个类的默认的'()'初始化方法
}

extension CompanyTravellerService:Validator{
    /// 查询旅客列表
    ///
    /// - Parameter form: 查询条件
    /// - Returns: 查询结果
    func getList(uid: String) ->Observable<[Traveller]>{
        let provider = RxMoyaProvider<CompanyTravellerRouter>()
       return provider.request(.search(uid:uid))
                .validateJustReturn(to: [Traveller.self])
        
        
    }
  
    
    func subsidiaryList(cityName:String) ->Observable<[HotelSubsidiary]> {
        
        let provider = RxMoyaProvider<CompanyTravellerRouter>()
        return provider.request(.subsidiaryList(cityName: cityName))
            .debugHttp(true)
            .validateJustReturn(to: [HotelSubsidiary.self])
        
        
        
        
        
    }
    
    
    
    
}

