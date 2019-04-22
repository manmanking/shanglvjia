//
//  CoCarService.swift
//  shop
//
//  Created by TBI on 2018/1/25.
//  Copyright © 2018年 TBI. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import SwiftyJSON

/// 单例
final class CoCarService {
    static let sharedInstance = CoCarService()
    private init() {} // 阻止其他对象使用这个类的默认的'()'初始化方法
}

// MARK: - 专车相关service
extension  CoCarService: Validator{
    
    
    /// 提交订单
    ///
    /// - Parameter model:
    /// - Returns:
    func commit(model:CoCarForm) -> Observable<String> {
        let provider = RxMoyaProvider<CoCarRouter>()
        return provider
            .request(.commit(model.toDict()))
            .debugHttp(true)
            .validateResponse()
            .map{ $0.stringValue }
    }
    
    
    /// 新版OBT 提交订单
    func commitOrder(parameters:SubmitCarOrderVO) ->Observable<String>{
        let provider = RxMoyaProvider<CoCarRouter>()
        return provider
            .request(.commitOrder(parameters.mj_keyValues() as! [String : Any]))
            .debugHttp(true)
            .validateResponse()
            .map{ $0.stringValue } 
    }
    
    
   
    
}
