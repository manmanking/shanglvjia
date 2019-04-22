//
//  CitysRouter.swift
//  shop
//
//  Created by zhanghao on 2017/7/11.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import Moya

enum CitysRouter {
    case citysDistrict(cityId:String)
}

extension CitysRouter : TargetType {
    /// 请求的基础路径
    var baseURL:URL {return URL(string: "\(BASE_URL)/citys")!}
    /// 拼接路径
    var path:String{
        switch self {
        case .citysDistrict(let cityId):
            return "/\(cityId)"
        }
    }
    
    var method:Moya.Method{
        switch self {
        case .citysDistrict:
            return .get
        }
    }
    /// 请求参数
    var parameters:[String:Any]?{
        switch self {
        case .citysDistrict:
            return nil
        }
    }
    /// 请求参数的发送方式
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .citysDistrict:
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
