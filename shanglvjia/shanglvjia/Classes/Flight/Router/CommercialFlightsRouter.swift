//
//  FlightsBusinessRouter.swift
//  shop
//
//  Created by SLMF on 2017/4/28.
//  Copyright © 2017年 zhangwangwang. All rights reserved.
//

import Foundation
import Moya

enum CommercialFlightsRouter {
    case list([String : Any])
}

extension CommercialFlightsRouter: TargetType {
    /// 请求的基础路径
    var baseURL:URL {return URL(string: "\(BASE_URL)/company/flights")!}
    /// 拼接路径
    var path:String{
        switch self {
        case .list:
            return "/"
        }
    }
    /// 请求方法
    var method:Moya.Method{
        switch self {
        case .list:
            return .get
        }
    }
    /// 请求参数
    var parameters:[String:Any]?{
        switch self {
        case .list(let params):
            return params
        }
    }
    /// 请求参数的发送方式
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .list:
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
    }}
