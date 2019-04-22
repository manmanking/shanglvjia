//
//  CitsService.swift
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
final class CitsService {
    static let sharedInstance = CitsService()
    private init() {} // 阻止其他对象使用这个类的默认的'()'初始化方法
}


extension CitsService:Validator{
    func getDestinations(form:DestinationsModel) -> Observable<[CitsCitys]> {
        let provider = RxMoyaProvider<CitsRouter>()
        return provider
            .request(.destinations(form.toDict()))
            .debugHttp(true)
            .validateJustReturn(to: [CitsCitys.self])
    }
    
    /// 获取当地参团游数据
    ///
    /// - Parameter form:
    /// - Returns:
    func getLocalDestinations(form:DestinationsModel) -> Observable<[LocalCitys]> {
        let provider = RxMoyaProvider<CitsRouter>()
        return provider
            .request(.destinations(form.toDict()))
            .debugHttp(true)
            .validateJustReturn(to: [LocalCitys.self])
    }
}
