//
//  TrainRouter.swift
//  shop
//
//  Created by TBI on 2017/12/25.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import Moya

enum CoTrainRouter {
    //GET /api/v2/trains/forIOS
    case list([String:Any])//fromStation:String,toStation:String,travelDate:String,psgParids:String
    case trainStation()//GET /api/v2/static/train //tbi-obt-staticinfo-api:7072
    case commit([String:Any])//POST /api/v2/trains
    case station()
    case checkStatus([String:Any])
    case trainBookMaxDate() //GET /api/v2/front/manage/train/maxdate
}
extension CoTrainRouter:TargetType{
    /// 请求的基础路径
    var baseURL:URL {return URL(string: "\(BASE_URL)")!}
    /// 拼接路径
    var path:String{
        switch self {
        case .list:
            return "/tbi-obt-train-api/api/v2/trains/forIOS"
        case .trainStation:
            return "/tbi-obt-staticinfo-api/api/v2/static/train/"
            
        case .commit:
            return "/tbi-obt-train-api/api/v2/trains"
        case .station:
            return "/getStationInfo"
        case .checkStatus:
            return "/tbi-obt-train-api/api/v2/trains/checkStatus"
        case .trainBookMaxDate:
            return "/tbi-obt-manage-api/api/v2/front/manage/train/maxdate"
        }
    }
    /// 请求方法
    var method:Moya.Method{
        switch self {
        case .list,.station,.trainStation,.trainBookMaxDate:
            return .get
        case .commit,.checkStatus:
            return .post
        }
    }
    /// 请求参数
    var parameters:[String:Any]?{
        switch self {
//        case .list(let params):
//            return ["psgParids":params.psgParids]
        case .station,.trainStation,.trainBookMaxDate:
            return nil
        case .commit(let params),.checkStatus(let params),.list(let params):
            return params
        }
    }
    /// 请求参数的发送方式
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .list,.trainStation:
            return TokenURLEncoding.default
        case .commit,.checkStatus:
            return TokenJSONEncoding.default
        case .station,.trainBookMaxDate:
            return URLEncoding.default
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

