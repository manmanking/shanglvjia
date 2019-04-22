//
//  HomesRouter.swift
//  shop
//
//  Created by TBI on 2017/6/12.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import Moya

enum HomesRouter {
    case list
    case version
    case getApprovel([String:Any])
    case submitApproval([String:Any])//POST /api/v1/approve/submit
    case revokeApproval([String:Any])//POST /api/v1/approve/revoke
    case cancelRequire([String:Any])//POST /api/v2/orders/require
    case cancelFlightOrder([String:Any])//POST /api/v2/orders/delete
    case cancelHotelOrder([String:Any])//POST /api/v2/orders/hotel_edit
    case cancelCarOrder([String:Any])//POST /api/v2/orders/car_edit
    case cancelTrainOrder([String:Any])//POST /api/v2/orders/train_edit
    case personalOrderCount()//GET /api/v2/orders/personal/count
    case mainHomeCarouselImage()//GET /api/v2/front/manage/carousel/tmc//CarouselResponse
    case appStoreVersion([String:Any])//GET /api/v2/front/manage/version/{systemType}
    
}
//http://60.28.59.67:8088/tbi-shop/api/v1/version/get
extension HomesRouter: TargetType {

    /// 请求的基础路径
    var baseURL:URL {return URL(string: "\(BASE_URL)")!}
    /// 拼接路径
    var path:String{
        switch self {
        case .list:
            return "/user/indexinfo/calcprice"
        case .version:
            return "/version/get"
        case .getApprovel:
            return "/tbi-obt-approve-api/api/v1/approve/getApver"
        case .submitApproval:
            return "/tbi-obt-approve-api/api/v1/approve/submit"
        case .revokeApproval:
            return "/tbi-obt-approve-api/api/v1/approve/revoke"
        case .cancelRequire:
            return "/tbi-obt-order-api/api/v2/orders/require"
        case .personalOrderCount:
            return "/tbi-obt-order-api/api/v2/orders/personal/count"
        case  .cancelFlightOrder:
            return "/tbi-obt-order-api/api/v2/orders/delete"
        case  .cancelCarOrder:
            return "/tbi-obt-order-api/api/v2/orders/car_edit"
        case  .cancelHotelOrder:
            return "/tbi-obt-order-api/api/v2/orders/hotel_edit"
        case  .cancelTrainOrder:
            return "/tbi-obt-order-api/api/v2/orders/train_edit"
        case .mainHomeCarouselImage:
            return "/tbi-obt-manage-api/api/v2/front/manage/carousel/tmc" //tbi-obt-manage-apiztd:7074
        case .appStoreVersion:
            return "/tbi-obt-manage-api/api/v2/front/manage/version/1" //tbi-obt-manage-apiztd:7074
        }
    }
    /// 请求方法
    var method:Moya.Method{
        switch self {
        case .list,.version,.personalOrderCount,.mainHomeCarouselImage,.appStoreVersion:
            return .get
        case .getApprovel,.submitApproval,.revokeApproval,.cancelRequire,.cancelFlightOrder,.cancelTrainOrder,.cancelCarOrder,.cancelHotelOrder:
            return .post
        }
    }
    /// 请求参数
    var parameters:[String:Any]?{
        switch self {
        case .list,.version,.personalOrderCount,.mainHomeCarouselImage:
            return nil
        case .getApprovel(let parameters),
             .appStoreVersion(let parameters):
            return parameters
        case .submitApproval(let parameters):
            return parameters
        case .revokeApproval(let parameters):
            return parameters
        case .cancelRequire(let parameters):
            return parameters
        case .cancelFlightOrder(let parameters):
            return parameters
        case .cancelTrainOrder(let parameters):
            return parameters
        case .cancelHotelOrder(let parameters):
            return parameters
        case .cancelCarOrder(let parameters):
            return parameters
        }
    }
    /// 请求参数的发送方式
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .list,.personalOrderCount,.mainHomeCarouselImage:
            return TokenURLEncoding.default
        case .version,.appStoreVersion:
            return URLEncoding.default
        case .getApprovel,.submitApproval,.revokeApproval,.cancelRequire,.cancelFlightOrder,.cancelTrainOrder,.cancelHotelOrder,.cancelCarOrder:
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
