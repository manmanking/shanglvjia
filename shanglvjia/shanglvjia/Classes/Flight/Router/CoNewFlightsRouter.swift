//
//  FlightsBusinessRouter.swift
//  shop
//
//  Created by SLMF on 2017/4/28.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import Moya

/// 企业机票新版相关接口
///
/// - list: 查询机票信息
/// - commit: 生成机票订单
enum CoNewFlightsRouter {
    case list([String : Any])
    case commit([String : Any])
}

extension CoNewFlightsRouter: TargetType {
    /// 请求的基础路径
    var baseURL:URL {return URL(string: "\(BASE_URL)/company/new_flights")!}
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
