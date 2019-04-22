//
//  JourneysRouter.swift
//  shop  行程接口
//
//  Created by TBI on 2017/6/14.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import Moya

enum CompanyJourneysRouter {
    case list([String:Any])
    case flightList([String:Any])
    case count()
    /// ------- NEWOBT -----
    case personalFlightList([String:Any]) //GET /api/v2/orders/personal/list/flight
}
extension CompanyJourneysRouter: TargetType {
    
    /// 请求的基础路径
    var baseURL:URL {return URL(string: "\(BASE_URL)/tbi-obt-order-api/api/v2/orders/personal")!}
    /// 拼接路径
    var path:String{
        switch self {
        case .list:
            return "/journeys"
        case .flightList:
            return "/flight/journeys"
        case .count:
            return "/journeys/count"
        case .personalFlightList:
            return "/list/flight"
        }
    }
    /// 请求方法
    var method:Moya.Method{
        switch self {
        case .list,.flightList,.count,.personalFlightList:
            return .get
        }
    }
    /// 请求参数
    var parameters:[String:Any]?{
        switch self {
        case .list(let params),.flightList(let params),.personalFlightList(let params):
            return params
        case .count:
            return nil
        }
    }
    /// 请求参数的发送方式
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .list,.flightList,.count,.personalFlightList:
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
