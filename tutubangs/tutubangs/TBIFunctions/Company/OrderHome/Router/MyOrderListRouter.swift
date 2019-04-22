//
//  MyOrderListRouter.swift
//  shanglvjia
//
//  Created by tbi on 2018/5/11.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import Moya

enum MyOrderListRouter {
    case orderList([String:Any])//GET /api/v2/orders/personal/app/list
    case scanQRCode(code:String)//GET /api/v2/users/qrcode/login/{qrinfo}
}
extension MyOrderListRouter : TargetType
{
    /// 请求的基础路径
    var baseURL: URL {
        switch self {
        case .orderList:
            return URL(string:"\(BASE_URL)/tbi-obt-order-api")!
        case .scanQRCode:
            return URL(string:"\(BASE_URL)/tbi-obt-user-api")!
        }
        
    }
    /// 拼接路径
    var path: String {
        switch self {
        case .orderList:
            return "/api/v2/orders/personal/app/list"
        case .scanQRCode(let code):
            return "/api/v2/users/qrcode/login/\(code)"
        }
    }
    /// 请求方法
    var method: Moya.Method {
        switch self {
        case .orderList,.scanQRCode:
            return .get
        }
    }
    /// 请求参数
    var parameters: [String : Any]? {
        switch self {
        case .orderList(let params):
            return params
        case .scanQRCode:
            return nil
        }
    }
    /// 请求参数的发送方式
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .orderList,.scanQRCode:
            return TokenURLEncoding.default
        }
    }
    /// 单元测试所需
    var sampleData: Data {
        return Data()
    }
    /// 请求类型 如普通请求，发送文件，下载文件
    var task: Task {
        return .request
    }
    
    
}

