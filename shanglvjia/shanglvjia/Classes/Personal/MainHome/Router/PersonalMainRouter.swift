//
//  PersonalMainRouter.swift
//  shanglvjia
//
//  Created by manman on 2018/7/27.
//  Copyright © 2018年 TBI. All rights reserved.
//

import Foundation
import RxSwift
import Moya


enum PersonalMainRouter {
    case mainHomeBanner()//GET /api/v2/static/banner
}

extension PersonalMainRouter:TargetType{
    /// 请求的基础路径
    var baseURL:URL {return URL(string: "\(BASE_URL)/tbi-cus-subject-api")!}
    /// 拼接路径
    var path:String{
        switch self {
        case .mainHomeBanner:
            return "/api/v2/static/banner"
        }
        
    }
    
    /// 请求方法
    var method:Moya.Method{
        switch self {
        case .mainHomeBanner:
            return .get
        }
    }
    /// 请求参数
    var parameters:[String:Any]?{
        switch self {
        case .mainHomeBanner:
            return nil
        }
    }
    /// 请求参数的发送方式
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .mainHomeBanner:
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
