//
//  HotelsRouter.swift
//  shop
//
//  Created by akrio on 2017/4/23.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import Moya
/// 酒店相关router
///
/// - hotCity: 获取热门城市
/// - list: 获取酒店列表
/// - cityInfo: 获取城市地标信息
/// - filiale: 获取分公司信息
/// - detail: 获取酒店详情
/// - validateCvv: 验证信息卡信息
/// -/travellers/search
/// -GET /api/v1/hotels/calcprice  计算担保金额
///GET /api/v1/hotels/testcvv

//POST /api/v1/hotel/preSale/detail
enum HotelsRouter{
    case hotCity
    case list([String:Any])
    case cityInfo([String:Any])
    case filiale([String:Any])
    case detail(id:String,parameters:[String:Any])
    case validateCvv([String:Any])
    case commit(parameters:[String:Any])
    case guarantee(parameters:[String:Any])
    case testcvv(parameters:[String:Any])
    
    //------OBT-------
    case hotelList([String:Any])//POST /api/v1/hotel/preSale/list
    case filialeList([String:Any])//GET /api/v1/adapter/hotel/support/branch
    case hotelDetail([String:Any])
    case hotelSubmitOrder([String:Any])//POST /api/v1/hotel/preSale/submitOrder
    case hotelGuaranteeAmount([String:Any]) //POST /api/v1/hotel/preSale/getGuaranteeAmount
    case hotelCreditVerify([String:Any])//GET /api/v1/adapter/hotel/support/luhnCheck
    case personalHotelDetail([String:Any])
}
extension HotelsRouter : TargetType {
    /// 请求的基础路径
    var baseURL:URL {return URL(string: "\(BASE_URL)")!}
    /// 拼接路径
    var path:String{
        switch self {
        case .hotCity:
            return "/hotcity"
        case .list,.commit:
            return "/"
        case .cityInfo:
            return "/cityinfo"
        case .filiale:
            return "/filiale"
        case .detail(let id,_):
            return "/\(id)"
        case .validateCvv:
            return "/testcvv"
        case .guarantee:
            return "/calcprice"
        case .testcvv:
            return "/testcvv"
        case .hotelList:
            return "/tbi-obt-hotel-api/api/v1/hotel/preSale/list"
        case .filialeList:
            return "/tbi-obt-adapter-api/api/v1/adapter/hotel/support/branch"
        case .hotelDetail:
            return "/tbi-obt-hotel-api/api/v1/hotel/preSale/detail" //tbi-obt-hotel-api:7090
        case .personalHotelDetail:
            return "/tbi-obt-hotel-api/api/v1/hotel/preSale/detailForCus" //tbi-obt-hotel-api:7090
        case .hotelSubmitOrder:
            return "/tbi-obt-hotel-api/api/v1/hotel/preSale/submitOrder"
        case .hotelGuaranteeAmount:
            return "/tbi-obt-hotel-api/api/v1/hotel/preSale/getGuaranteeAmount"
        case .hotelCreditVerify:
            return "/tbi-obt-adapter-api/api/v1/adapter/hotel/support/luhnCheck"
            
        }
    }
    /// 请求方法
    var method:Moya.Method{
        switch self {
        case .hotCity,.list,.cityInfo,.filiale,.detail,.validateCvv,.guarantee,.testcvv,.filialeList,.hotelCreditVerify:
            return .get
        case .commit,.hotelList,.hotelDetail,.personalHotelDetail,.hotelSubmitOrder,.hotelGuaranteeAmount:
            return .post
        }
    }
    /// 请求参数
    var parameters:[String:Any]?{
        switch self {
        case .hotCity:
            return nil
        case .list(let params),.cityInfo(let params),.filiale(let params),.detail(_,let params),.validateCvv(let params),.commit(let params),.guarantee(let params),.testcvv(let params),.hotelList(let params),.filialeList(let params),.hotelDetail(let params),.hotelSubmitOrder(let params),.hotelGuaranteeAmount(let params),.hotelCreditVerify(let params),.personalHotelDetail(let params):
            return params
        }
    }
    /// 请求参数的发送方式
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .hotCity,.cityInfo,.validateCvv,.testcvv:
            return URLEncoding.default
        case .guarantee,.list,.detail,.filialeList,.hotelCreditVerify:
            return TokenURLEncoding.default
        case .filiale,.commit,.hotelList,.hotelDetail,.personalHotelDetail,.hotelSubmitOrder:
            return TokenJSONEncoding.default
        case .hotelGuaranteeAmount:
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
