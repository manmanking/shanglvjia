//
//  DemoService.swift
//  shanglvjia
//
//  Created by akrio on 2017/4/13.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import RxSwift
import Moya
@testable import shanglvjia

/// 单例
final class DemoService{
    
    static let sharedInstance = DemoService()
    private init() {} // 阻止其他对象使用这个类的默认的'()'初始化方法
    
}

// MARK: - DemoService的实现
extension  DemoService{
    
    /// 获取用户列表
    ///
    /// - Parameter page: 页码
    /// - Returns: 用户列表
    func getList(page:Int = 1) -> Observable<[DemoModel.ListItem]>{
        let provider = RxMoyaProvider<DemoRouter>()
        return provider
            .request(.list(page: page))
            .validateJustReturn(to: [DemoModel.ListItem.self])
    }
    /// 创建用户
    ///
    /// - Parameter user: 用户信息
    /// - Returns: 创建的用户信息详情
    func create(_ user:DemoModel.UserPo) -> Observable<DemoModel.UserItem>{
        let provider = RxMoyaProvider<DemoRouter>()
        return provider
            .request(.create(parameters: user.toDict()))
            .validateJustReturn(to: DemoModel.UserItem.self)

    }
    /// 获取用户详情
    ///
    /// - Parameter id: 用户id
    /// - Returns: 用户信息详情
    func getDetailBy(_ id:String) -> Observable<DemoModel.UserItem>{
        let provider = RxMoyaProvider<DemoRouter>()
        return provider
            .request(.detail(id: id))
            .validateJustReturn(to: DemoModel.UserItem.self)
        
    }
    /// 删除用户信息
    ///
    /// - Parameter id: 待删除的用户id
    /// - Returns: 是否删除成功
    func deleteBy(_ id:String) -> Observable<DemoModel.UserItem>{
        let provider = RxMoyaProvider<DemoRouter>()
        return provider
            .request(.delete(id: id))
            .validateJustReturn(to: DemoModel.UserItem.self)
        
    }
    /// 更新用户信息
    ///
    /// - Parameters:
    ///   - id: 用户id
    ///   - user: 更新的用户信息
    /// - Returns: 更新后的用户信息
    func update(_ id:String,user:DemoModel.UserPo) -> Observable<DemoModel.UserItem>{
        let provider = RxMoyaProvider<DemoRouter>()
        return provider
            .request(.update(id: id, parameters: user.toDict()))
            .validateJustReturn(to: DemoModel.UserItem.self)
        
    }
}
