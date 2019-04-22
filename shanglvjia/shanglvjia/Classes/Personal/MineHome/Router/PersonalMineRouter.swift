//
//  PersonalMineRouter.swift
//  shanglvjia
//
//  Created by tbi on 23/08/2018.
//  Copyright © 2018 TBI. All rights reserved.
//

import UIKit
import Moya

enum PersonalMineRouter {
    case queryPersonalBaseInfo()//GET /api/v2/users/infos/queryUserAppend
    case bindUserAppend([String:Any])//POST /api/v2/users/login/bindUserAppend

}
extension PersonalMineRouter: TargetType {
    var baseURL: URL {
        return URL(string: "\(BASE_URL)/tbi-cus-user-api")!
    }
    
    var path: String {
        switch self {
        case .queryPersonalBaseInfo:
            return "/api/v2/users/infos/queryUserAppend"
        case .bindUserAppend:
            return "/api/v2/users/login/bindUserAppend"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .queryPersonalBaseInfo:
            return .get
        case .bindUserAppend:
            return .post
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .queryPersonalBaseInfo:
            return nil
        case .bindUserAppend(let params):
            return params
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .queryPersonalBaseInfo:
            return TokenURLEncoding.default
        case .bindUserAppend:
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
