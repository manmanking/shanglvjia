//
//  SpecialRouter.swift
//  shop
//
//  Created by manman on 2017/7/5.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import RxSwift
import Moya


//GET /api/v1/special/mains
enum SpecialRouter {
    case mainCategory
    case list([String:Any])
    case price(id:String,categoryId:String,[String:Any])
    case categorys(id:String)
    case detail(id:String)
    case submitSpecial([String:Any])
    case advs([String:Any])
}

extension SpecialRouter:TargetType{
    /// 请求的基础路径
    var baseURL:URL {return URL(string: "\(BASE_URL)")!}
    /// 拼接路径
    var path:String{
        switch self {
        case .mainCategory:
            return "/special/mains/productTypes"
        case .list:
            return "/special/mains"
        case .price(let id,let categoryId,_):
            return "/special/mains/\(id)/categorys/\(categoryId)/prices"
        case .detail(let id):
            return "/special/mains/\(id)"
        case .categorys(let id):
            return "/special/mains/\(id)/categorys"
        case .submitSpecial:
            return "/special/orders"
        case .advs:
            return "/special/travels/advs"
        }
        
    }
    /// 请求方法
    var method:Moya.Method{
        switch self {
        case .mainCategory,.list,.price,.detail,.categorys,.advs:
            return .get
        case .submitSpecial:
            return .post
        }
    }
    /// 请求参数
    var parameters:[String:Any]?{
        switch self {
        case .list(let params),.price(_ , _,let params),.submitSpecial(let params),.advs(let params):
            return params
        case .mainCategory,.detail,.categorys:
            return nil
        }
    }
    /// 请求参数的发送方式
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .mainCategory,.list,.price,.detail,.categorys,.advs:
            return TokenURLEncoding.default
        case .submitSpecial:
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
