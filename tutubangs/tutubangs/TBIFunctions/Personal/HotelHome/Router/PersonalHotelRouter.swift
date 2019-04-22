//
//  PersonalHotelRouter.swift
//  shanglvjia
//
//  Created by manman on 2018/7/30.
//  Copyright © 2018年 TBI. All rights reserved.
//

import Foundation
import RxSwift
import Moya


enum PersonalHotelRouter {
    case specialProductDetail([String:Any])//POST /api/v2/hotel/special/productDetail
    case specialProductList([String:Any]) //POST /api/v2/hotel/special/productList
    case specialProductSubmitOrder([String:Any]) //POST /api/v2/hotel/hotelOrder/submit
    case personalHotelList([String:Any])//POST /api/v1/nomalHotel/list
    case personalHotelDetail([String:Any])//POST /api/v1/nomalHotel/detail
}

extension PersonalHotelRouter:TargetType {
    
    /// 请求的基础路径
    var baseURL:URL {return URL(string: "\(BASE_URL)/tbi-cus-hotel-api")!} //tbi-cus-manage-api
    /// 拼接路径
    var path:String{
        switch self {
        case .specialProductDetail:
            return "/api/v2/hotel/special/productDetail"
        case .specialProductList:
            return "/api/v2/hotel/special/productList"
        case .specialProductSubmitOrder:
            return "/api/v2/hotel/hotelOrder/submit"
        case .personalHotelList:
            return "/api/v1/nomalHotel/list"
        case .personalHotelDetail:
            return "/api/v1/nomalHotel/detailForCus"
        }
        
    }
    
    /// 请求方法
    var method:Moya.Method{
        switch self {
        case .specialProductDetail,.specialProductList,
             .specialProductSubmitOrder,.personalHotelList,
             .personalHotelDetail:
            return .post
            
        }
    }
    /// 请求参数
    var parameters:[String:Any]?{
        switch self {
        case .specialProductDetail(let params),.specialProductList(let params),
             .specialProductSubmitOrder(let params),.personalHotelList(let params),
             .personalHotelDetail(let params):
            return params
        }
    }
    /// 请求参数的发送方式
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .specialProductDetail,.specialProductList,
             .specialProductSubmitOrder,.personalHotelList,
             .personalHotelDetail:
            return  TokenJSONEncoding.default
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

