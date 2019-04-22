//
//  VisaRouter.swift
//  shanglvjia
//
//  Created by manman on 2018/7/16.
//  Copyright © 2018年 TBI. All rights reserved.
//

import Foundation
import RxSwift
import Moya


enum VisaRouter {
    case list([String:Any])//POST /api/v1/visa/list
    case cityList()//GET /api/v1/travel/city
    case countyList()//GET /api/v1/visa/country
    case submitOrderVisa([String:Any])// POST /api/v1/visa/orderVisa
    case detail(productId:String)//GET /api/v1/visa/detail/{id}
}

extension VisaRouter:TargetType{
    /// 请求的基础路径
    var baseURL:URL {return URL(string: "\(BASE_URL)/tbi-cus-travel-api")!}
    /// 拼接路径
    var path:String{
        switch self {
        case .list:
            return "/api/v1/visa/list"
        case .cityList:
            return "/api/v1/travel/city"
        case .countyList:
            return "/api/v1/visa/country"
        case .submitOrderVisa:
            return "/api/v1/visa/orderVisa"
        case .detail(let productId):
            return "/api/v1/visa/detail/\(productId)"
        
        
        }
        
    }
    
    /// 请求方法
    var method:Moya.Method{
        switch self {
        case .list,.submitOrderVisa:
            return .post
        case .cityList,.countyList,.detail:
            return .get
        }
    }
    /// 请求参数
    var parameters:[String:Any]?{
        switch self {
        case .list(let params),.submitOrderVisa(let params):
            return params
        case .cityList,.countyList,.detail:
            return nil
        }
    }
    /// 请求参数的发送方式
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .list,.cityList,.submitOrderVisa,.detail:
            return  TokenJSONEncoding.default
        case .countyList:
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
