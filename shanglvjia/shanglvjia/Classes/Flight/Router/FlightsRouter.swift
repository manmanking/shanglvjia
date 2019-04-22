//
//  FlightsRouter.swift
//  shop
//
//  Created by akrio on 2017/4/24.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import Moya

enum FlightsRouter {
    case list([String:Any])
    case commit([String:Any])
    
    // ----NEWOBT----
    case flightList([String:Any])//GET /api/v2/airs
    case checkInsurance([String:Any])//POST /api/v2/airs/checkInsurance
    case commitOrder([String:Any])//POST /api/v2/airs
    case rightFlight([String:Any])//POST /api/v2/airs/getRightFlight
}
extension FlightsRouter:TargetType{
    /// 请求的基础路径
    var baseURL:URL {return URL(string: "\(BASE_URL)/tbi-obt-air-api/api/v2/airs")!}
    /// 拼接路径
    var path:String{
        switch self {
        case .list,.commit:
            return "/"
        case .flightList:
            return ""
        case .checkInsurance:
            return "/checkInsurance"
        case .commitOrder:
            return ""
        case .rightFlight:
            return "/getRightFlight"
        }
        
    }
    /// 请求方法
    var method:Moya.Method{
        switch self {
        case .list,.flightList:
            return .get
        case .commit,.checkInsurance,.commitOrder,.rightFlight:
            return .post
        }
    }
    /// 请求参数
    var parameters:[String:Any]?{
        switch self {
        case .list(let params),.commit(let params),
             .flightList(let params),.checkInsurance(let params),
             .commitOrder(let params),.rightFlight((let params)):
            return params
        }
    }
    /// 请求参数的发送方式
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .list,.flightList:
            return TokenURLEncoding.default
        case .commit,.checkInsurance,.commitOrder,.rightFlight:
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
