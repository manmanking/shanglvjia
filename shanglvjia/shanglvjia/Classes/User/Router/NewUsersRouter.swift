//
//  NewUsersRouter.swift
//  shop
//
//  Created by TBI on 2018/2/9.
//  Copyright © 2018年 TBI. All rights reserved.
//

import Foundation
import Moya

/// 新版用户router
///
/// - policy: 获取政策描述
enum NewUsersRouter {
    case policy(id:String)
}
extension NewUsersRouter : TargetType{
    
    /// 请求的基础路径
    var baseURL:URL {return URL(string: "\(BASE_USER_URL)/users")!}
    
    /// 拼接路径
    var path:String{
        switch self {
        case .policy(let id):
            return "/policy/\(id)"
        }
    }
    /// 请求方法
    var method:Moya.Method{
        switch self {
        case .policy:
            return .get
      
        }
    }
    /// 请求参数
    var parameters:[String:Any]?{
        switch self {
        case .policy:
            return nil
        }
    }
    /// 请求参数的发送方式
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .policy:
            return TokenURLEncoding.default
       
        }
    }
    /// 请求类型 如普通请求，发送文件，下载文件
    var task: Task {
        return .request
    }
    /// 单元测试所需
    var sampleData: Data {
        return Data()
    }
}
