//
//  PersonalMessageRouter.swift
//  shanglvjia
//
//  Created by tbi on 05/09/2018.
//  Copyright © 2018 TBI. All rights reserved.
//


import Foundation
import Moya

enum PersonalMessageRouter {
    case personalMessageOrder([String:Any])//GET /api/v1/push/history/order
    case personalMessageOthers([String:Any])//GET /api/v1/push/history/others
}
extension PersonalMessageRouter:TargetType{
    var baseURL: URL {
        return URL(string: "\(BASE_URL)/tbi-cus-push-api")!
    }
    
    var path: String {
        switch self {
        case .personalMessageOrder:
            return "/api/v1/push/history/order"
        case .personalMessageOthers:
            return "/api/v1/push/history/others"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .personalMessageOrder,.personalMessageOthers:
            return .get
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .personalMessageOrder(let params),.personalMessageOthers(let params):
            return params
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        
        case .personalMessageOrder,.personalMessageOthers:
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
