//
//  CoOldFlightsRouter.swift
//  shop
//
//  Created by akrio on 2017/5/19.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import Moya

/// 企业老版机票相关接口
///
/// - list: 航班查询
/// - commit: 机票预定
enum CoOldFlightsRouter {
    case list([String : Any])
    case commit([String : Any])
}

extension CoOldFlightsRouter: TargetType {
    /// 请求的基础路径
    var baseURL:URL {return URL(string: "\(BASE_URL)/company/old_flights")!}
    /// 拼接路径
    var path:String{
        switch self {
        case .list,.commit:
            return "/"
        }
    }
    /// 请求方法
    var method:Moya.Method{
        switch self {
        case .list:
            return .get
        case .commit:
            return .post
        }
    }
    /// 请求参数
    var parameters:[String:Any]?{
        switch self {
        case .list(let params),.commit(let params):
            return params
        }
    }
    /// 请求参数的发送方式
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .list:
            return TokenURLEncoding.default
        case .commit:
            return TokenJSONEncoding.default
        }
    }
    /// 请求类型 如普通请求，发送文件，下载文件
    var task: Task {
        return .request
    }
    /// 单元测试所需
    var sampleData: Data {
        return Data()
    }}
