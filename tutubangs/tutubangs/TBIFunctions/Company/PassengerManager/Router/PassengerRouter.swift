//
//  PassengerRouter.swift
//  shanglvjia
//
//  Created by manman on 2018/3/16.
//  Copyright © 2018年 TBI. All rights reserved.
//

import Foundation
import Moya
enum PassengerRouter{

    case  passengerList(parameters:[String:Any])//POST /api/v2/users/passage/query
}
extension PassengerRouter : TargetType {
    /// 请求的基础路径
    var baseURL:URL {return URL(string: "\(BASE_URL)/tbi-obt-user-api")!}
    /// 拼接路径
    var path:String{
        switch self {
        case .passengerList:
            return "/api/v2/users/passage/query"
            
        }
    }
    /// 请求方法
    var method:Moya.Method{
        switch self {
            case .passengerList:
                return .get
        }
    }
    /// 请求参数
    var parameters:[String:Any]?{
        switch self {
            case .passengerList(let params):
                return params
        }
    }
    /// 请求参数的发送方式
    var parameterEncoding: ParameterEncoding {
        switch self {
            case .passengerList:
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
