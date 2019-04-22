//
//  FeedBackRouter.swift
//  shop
//
//  Created by zhanghao on 2017/7/10.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import Moya

enum FeedBackRouter {
    case feedback(parameters:[String:Any])
    case companyfeedback(parameters:[String:Any])
}

extension FeedBackRouter : TargetType{
    var baseURL:URL {return URL(string: "\(BASE_URL)")!}
    
    var path:String{
        switch self {
        case .feedback:
            return "/tbi-obt-manage-api/api/v2/front/manage/feedback"
        case .companyfeedback:
            return "/company/feedback"
        }
    }
    
    var method:Moya.Method{
        switch self {
        case .feedback,.companyfeedback:
            return .post
        }
    }
    
    var parameters:[String:Any]?{
        switch self {
        case .feedback(let parameters),.companyfeedback(let parameters):
            return parameters
        }
    }
    /// 请求参数的发送方式
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .feedback,.companyfeedback:
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
