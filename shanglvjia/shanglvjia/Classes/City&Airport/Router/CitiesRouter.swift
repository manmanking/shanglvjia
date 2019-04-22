//
//  CitiesRouter.swift
//  shop
//
//  Created by akrio on 2017/4/26.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import Moya

enum CitiesRouter {
    case list([String:Any])
    case airPortList
    case hotelCity
    case landMark([String:Any])
    case cityTravelPolicy([String:Any]) //GET /api/v1/adapter/hotel/support/geoForApp
    case prefecturelevelCity([String:Any])//GET /api/v1/hotel/preSale/getElongCityInfo
    case specialHotelCity([String:Any])//POST /api/v2/hotel/hotelSupport/allCitys//tbi-cus-hotel-api:7183
}
extension CitiesRouter:TargetType{
    /// 请求的基础路径
    var baseURL:URL {return URL(string: "\(BASE_URL)")!} //BASE_URL_AIRPORT// 172.17.18.98:tbi-obt-staticinfo-api
    /// 拼接路径
    var path:String{
        switch self {
        case .list:
            return "/citys"
        case .airPortList:
            return "/tbi-obt-staticinfo-api/api/v2/static/airport"//"/api/v2/static/airport"
        case .hotelCity:
            return "/tbi-obt-staticinfo-api/api/v2/static/hotelcity/hotelCitys"
        case .landMark:
            return "/tbi-obt-adapter-api/api/v1/adapter/hotel/support/geo" //GET /api/v1/adapter/hotel/support/geo
        case .prefecturelevelCity:
            return "/tbi-obt-hotel-api/api/v1/hotel/preSale/getElongCityInfo"
        case .cityTravelPolicy:
            return "/tbi-obt-adapter-api/api/v1/adapter/hotel/support/geoForApp"
        case .specialHotelCity:
            return "tbi-cus-hotel-api/api/v2/hotel/hotelSupport/allCitys/"
        
        }
    }
    /// 请求方法
    var method:Moya.Method{
        switch self {
        case .list,.airPortList,.hotelCity,
             .landMark,.prefecturelevelCity,
             .cityTravelPolicy:
            return .get
        case .specialHotelCity:
            return .post
            
        }
    }
    /// 请求参数
    var parameters:[String:Any]?{
        switch self {
        case .list(let params),.landMark(let params),
             .prefecturelevelCity(let params),
             .cityTravelPolicy(let params),.specialHotelCity(let params):
            return params
        case .airPortList,.hotelCity:
            return nil
        }
    }
    /// 请求参数的发送方式
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .list,.airPortList,.hotelCity,.prefecturelevelCity:
            return TokenURLEncoding.default
        case .landMark,.cityTravelPolicy:
            return TokenURLEncoding.default
        case .specialHotelCity:
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
