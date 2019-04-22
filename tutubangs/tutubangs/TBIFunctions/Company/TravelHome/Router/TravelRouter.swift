//
//  TravelRouter.swift
//  shop
//
//  Created by akrio on 2017/6/27.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import RxSwift
import Moya

//提交定制化旅游 submitCustomTravel

//GET /api/v1/family/travellers
//POST /api/v1/family/travellers
enum TravelRouter {
    case list([String:Any])
    case price(id:String,categoryId:String,[String:Any])
    case detail(id:String)
    case categorys(id:String)
    case submitSpecial([String:Any])
    case submitTravel([String:Any])
    case travellerList
    case updateTraveller([String:Any])
    case deleteTraveller([String:Any])
    case submitCustomTravel([String:Any])  //提交定制化旅游
    case familyTraveller()//获得家属列表
    case familyAddTraveller([String:Any])//添加家属人员
    
}
extension TravelRouter:TargetType{
    /// 请求的基础路径
    var baseURL:URL {return URL(string: "\(BASE_URL)")!}
    /// 拼接路径
    var path:String{
        switch self {
        case .list:
            return "special/travels"
        case .price(let id,let categoryId,_):
            return "special/travels/\(id)/categorys/\(categoryId)/prices"
        case .detail(let id):
            return "special/travels/\(id)"
        case .categorys(let id):
            return "special/travels/\(id)/categorys"
        case .submitSpecial:
            return "special/orders"
        case .submitTravel:
            return "special/orders/travel"
        case .travellerList:
            return "travel/travellers"
        case .updateTraveller:
            return "travel/travellers"
        case .deleteTraveller:
            return "travel/travellers"
        case .submitCustomTravel:
            return "travel/custom"
        case .familyTraveller:
            return "family/travellers"
        case .familyAddTraveller:
            return "/family/travellers"
        }
    }
    
    /// 请求方法
    var method:Moya.Method{
        switch self {
        case .list,.price,.detail,.categorys,.travellerList,.familyTraveller:
            return .get
        case .submitTravel,.submitSpecial,.submitCustomTravel,.familyAddTraveller:
            return .post
        case .updateTraveller:
            return .put
        case .deleteTraveller:
            return .delete
        }
    }
    /// 请求参数
    var parameters:[String:Any]?{
        switch self {
        case .list(let params),.price(_ , _,let params),.submitTravel(let params),.submitSpecial(let params),.updateTraveller(let params),.deleteTraveller(let params),.submitCustomTravel(let params),.familyAddTraveller(let params):
            return params
        case .detail,.categorys,.travellerList,.familyTraveller:
            return nil
        }
    }
    /// 请求参数的发送方式
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .list,.price,.detail,.categorys,.travellerList,.deleteTraveller,.familyTraveller:
            return TokenURLEncoding.default
        case .submitTravel,.submitSpecial,.updateTraveller,.submitCustomTravel,.familyAddTraveller:
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
