//
//  MyTripRouter.swift
//  shop
//
//  Created by zhanghao on 2017/7/12.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import Moya

enum MyTripRouter {
    case myTrip
    case trip([String:Any]) // GET /api/v2/orders/personal/app/journey
}
extension MyTripRouter: TargetType {
    /// 请求的基础路径
    var baseURL:URL {return URL(string: "\(BASE_URL)")!}
    /// 拼接路径
    var path:String{
        switch self {
        case .myTrip:
            return "/myTrip"
        case .trip:
            return "/tbi-obt-order-api/api/v2/orders/personal/app/journey"
        }
    }
    /// 请求方法
    var method:Moya.Method{
        switch self {
        case .myTrip,.trip:
            return .get
        
        }
    }
    /// 请求参数
    var parameters:[String:Any]?{
        switch self {
        case .myTrip:
            return nil
        case .trip(let parameters):
            return parameters
        }
    }
    /// 请求参数的发送方式
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .myTrip,.trip:
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
