//
//  CoCarRouter.swift
//  shop
//
//  Created by TBI on 2018/1/25.
//  Copyright © 2018年 TBI. All rights reserved.
//

import Foundation
import Moya

enum CoCarRouter {
    case commit([String:Any])
    
    case commitOrder([String:Any])//POST /api/v1/car/preSale/submit
}
extension CoCarRouter:TargetType{
    /// 请求的基础路径
    var baseURL:URL {return URL(string: "\(BASE_URL)/tbi-obt-car-api")!}
    /// 拼接路径
    var path:String{
        switch self {
        case .commit:
            return ""
        case .commitOrder:
            return "/api/v1/car/preSale/submit"
        }
    }
    /// 请求方法
    var method:Moya.Method{
        switch self {
        case .commit:
            return .post
        case .commitOrder:
            return .post
        }
    }
    /// 请求参数
    var parameters:[String:Any]?{
        switch self {
        case .commit(let params),.commitOrder(let params):
            return params
        }
    }
    /// 请求参数的发送方式
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .commit,.commitOrder:
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
    }
}

