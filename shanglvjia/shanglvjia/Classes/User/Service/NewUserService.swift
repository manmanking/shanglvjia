//
//  NewUserService.swift
//  shop
//
//  Created by TBI on 2018/2/9.
//  Copyright © 2018年 TBI. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import SwiftyJSON
/// 单例
final class NewUserService{
    static let sharedInstance = NewUserService()
    private init() {} // 阻止其他对象使用这个类的默认的'()'初始化方法
}

extension  NewUserService : Validator{
    
    
    /// id
    ///
    /// - Parameter id: id
    /// - Returns: 差旅政策
    func getPolicy(id:String) ->Observable<UserPolicy> {
        let provider = RxMoyaProvider<NewUsersRouter>()
        return provider.request(.policy(id: id))
            .debugHttp(true)
            .validateJustReturn(to: UserPolicy.self)
        
    }
    
    
}
