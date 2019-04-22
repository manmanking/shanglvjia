//
//  PersonalTravelRouter.swift
//  shanglvjia
//
//  Created by manman on 2018/7/30.
//  Copyright © 2018年 TBI. All rights reserved.
//

import Foundation
import Moya


enum PersonalTravelRouter {
    case personalTravelList([String:Any])//POST /api/v1/travel/list
    case personalTravelDetail(id:String)//GET /api/v1/travel/independent/detail/{id}
    case personalNearbyDetail(id:String)//GET /api/v1/travel/single/detail/{id}
    case personalTravelOrder([String:Any])//POST /api/v1/travel/add
}

extension PersonalTravelRouter:TargetType{
    
    /// 请求的基础路径
    var baseURL:URL {return URL(string: "\(BASE_URL)/tbi-cus-travel-api")!}
    /// 拼接路径
    var path:String{
        switch self {
        case .personalTravelList:
            return "/api/v1/travel/list"
        case .personalTravelDetail(let id):
            return "/api/v1/travel/independent/detail/\(id)"
        case .personalTravelOrder:
            return "/api/v1/travel/add"
        case .personalNearbyDetail(let id):
            return "/api/v1/travel/single/detail/\(id)"
        }
        
    }
    
    /// 请求方法
    var method:Moya.Method{
        switch self {
        case .personalTravelList,.personalTravelOrder:
            return .post
        case .personalNearbyDetail,.personalTravelDetail:
            return .get
        }
    }
    /// 请求参数
    var parameters:[String:Any]?{
        switch self {
        case .personalTravelList(let params),.personalTravelOrder(let params):
            return params
        case .personalTravelDetail,.personalNearbyDetail:
            return nil
        }
    }
    /// 请求参数的发送方式
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .personalTravelList,.personalTravelOrder:
            return  TokenJSONEncoding.default
        case .personalTravelDetail,.personalNearbyDetail:
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
