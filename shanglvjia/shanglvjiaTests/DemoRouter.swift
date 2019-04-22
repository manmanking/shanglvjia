//
//  DemoRouter.swift
//  shanglvjia
//
//  Created by akrio on 2017/4/13.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON
/// 用户路由
///
/// - list: 用户列表
/// - detail: 用户详情
/// - create: 创建用户
/// - delete: 删除用户
/// - update: 更新用户信息
enum DemoRouter {
    case list(page:Int)
    case detail(id:String)
    case create(parameters:[String:Any])
    case delete(id:String)
    case update(id:String,parameters:[String:Any])
}
extension DemoRouter : TargetType{
    
    /// 请求的基础路径
    var baseURL:URL {return URL(string: "http://localhost:3000")!}
    
    /// 拼接路径
    var path:String{
        switch self {
        case .list,.create:
            return "/demo"
        case .detail(let id),.delete(let id),.update(let id,_):
            return "/demo/\(id)"
        }
    }
    /// 请求方法
    var method:Moya.Method{
        switch self {
        case .list,.detail:
            return .get
        case .create:
            return .post
        case .delete:
            return .delete
        case .update:
            return .put
        }
    }
    /// 请求参数
    var parameters:[String:Any]?{
        switch self {
        case .list(let page):
            var params:[String:Any] = [:]
            params["page"] = page
            return params
        case .create(let parameters),.update(_,let parameters):
            return parameters
        case .detail,.delete:
            return nil
        }
    }
    /// 请求参数的发送方式
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .create,.update:
            return JSONEncoding.default
        case .detail,.list,.delete:
            return URLEncoding.default // Send parameters in URL
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
