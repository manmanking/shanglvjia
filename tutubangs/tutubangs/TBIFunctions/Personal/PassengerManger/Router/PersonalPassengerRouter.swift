//
//  PersonalPassengerRouter.swift
//  shanglvjia
//
//  Created by manman on 2018/7/24.
//  Copyright © 2018年 TBI. All rights reserved.
//

import Foundation
import RxSwift
import Moya


enum PersonalPassengerRouter {
    case add([String:Any])//POST /api/v2/manager/traveller/add
    case delete([String:Any]) //POST /api/v2/manager/traveller/del
    case list([String:Any]) //POST /api/v2/manager/traveller/list
    case modify([String:Any])//POST /api/v2/manager/traveller/modify
}

extension PersonalPassengerRouter:TargetType {
    
    /// 请求的基础路径
    var baseURL:URL {return URL(string: "\(BASE_URL)/tbi-cus-manage-api")!} //tbi-cus-manage-api
    /// 拼接路径
    var path:String{
        switch self {
        case .add:
            return "/api/v2/manager/traveller/add"
        case .list:
            return "/api/v2/manager/traveller/list"
        case .delete:
            return "/api/v2/manager/traveller/del"
        case .modify:
            return "/api/v2/manager/traveller/modify"
            
            
        }
        
    }
    
    /// 请求方法
    var method:Moya.Method{
        switch self {
        case .list,.add,.modify,.delete:
            return .post
        
        }
    }
    /// 请求参数
    var parameters:[String:Any]?{
        switch self {
        case .list(let params),.add(let params),.delete(let params),.modify(let params):
            return params
        }
    }
    /// 请求参数的发送方式
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .list,.add,.delete,.modify:
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
