//
//  CoOldExanimeRouter.swift
//  shop
//
//  Created by akrio on 2017/5/27.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import Moya

/// 企业老版审批相关router
///
/// - list: 审批订单列表
/// - agree: 同意
/// - reject: 拒绝
/// - nextApver: 获取下级审批人Id
enum CoOldExamineRouter {
    case list([String:Any])
    case agree(String,[String:Any])
    case reject(String,[String:Any])
    case nextApver(String)
}
extension CoOldExamineRouter:TargetType{
    /// 请求的基础路径
    var baseURL:URL {return URL(string: "\(BASE_URL)/company/old_approvals")!}
    /// 拼接路径
    var path:String{
        switch self {
        case .list:
            return "/lite"
        case .agree(let id,_):
            return "\(id)/agree"
        case .reject(let id,_):
            return "\(id)/reject"
        case .nextApver(let id):
            return "\(id)/next_apver"
        }
    }
    /// 请求方法
    var method:Moya.Method{
        switch self {
        case .list,.nextApver:
            return .get
        case .agree,.reject:
            return .patch
        }
    }
    /// 请求参数
    var parameters:[String:Any]?{
        switch self {
        case .list(let params),.agree(_,let params),.reject(_,let params):
            return params
        case .nextApver:
            return nil
        }
    }
    /// 请求参数的发送方式
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .list,.nextApver:
            return TokenURLEncoding.default
        case .agree,.reject:
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
