//
//  CitsRouter.swift
//  shop
//
//  Created by zhanghao on 2017/7/11.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import RxSwift
import Moya


//GET /api/v1/cits 根据接口名称和参数获取值
//GET /api/v1/cits/destinations 获取旅游目的地
//GET /api/v1/cits/getDomesticGroupRoutes 获取国内参团线路列表
//GET /api/v1/cits/getOutBoundProductDest 获取国际目的地列表
//GET /api/v1/cits/getOutboundGroupRoutes 获取出境参团线路列表
//GET /api/v1/cits/getProductDest 获取国内目的地列表

enum CitsRouter {
    case destinations([String:Any])
    case getDomesticGroupRoutes([String:Any])   //  已废
    case getOutBoundProductDest                 //  已废
    case getOutboundGroupRoutes([String:Any])   //  已废
    case getProductDest                         //  已废
}

extension CitsRouter:TargetType{
    /// 请求的基础路径
    var baseURL:URL {return URL(string: "\(BASE_URL)/cits")!}
    /// 拼接路径
    var path:String{
        switch self {
        case .destinations:
            return "/destinations"
        case .getDomesticGroupRoutes:
            return "/getDomesticGroupRoutes"
        case .getOutBoundProductDest:
            return "/getOutBoundProductDest"
        case .getOutboundGroupRoutes:
            return "/getOutboundGroupRoutes"
        case .getProductDest:
            return "/getProductDest"
        }
    }
    /// 请求方法
    var method:Moya.Method{
        switch self {
        case .destinations,.getDomesticGroupRoutes,.getOutBoundProductDest,.getOutboundGroupRoutes,.getProductDest:
            return .get
        }
    }
    /// 请求参数
    var parameters:[String:Any]?{
        switch self {
        case .destinations(let params),.getDomesticGroupRoutes(let params),.getOutboundGroupRoutes(let params):
            return params
        case .getOutBoundProductDest,.getProductDest:
            return nil
        }
    }
    /// 请求参数的发送方式
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .destinations,.getDomesticGroupRoutes,.getOutBoundProductDest,.getOutboundGroupRoutes,.getProductDest:
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
