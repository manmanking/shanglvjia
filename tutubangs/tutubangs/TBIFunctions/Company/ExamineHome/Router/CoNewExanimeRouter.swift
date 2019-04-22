//
//  CoNewExanimeRouter.swift
//  shop
//
//  Created by akrio on 2017/5/27.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import RxSwift
import Moya
/// 企业新版审批相关router
///
/// - list: 审批订单列表
/// - agree: 同意
/// - reject: 拒绝
/// - nextApver: 获取下级审批人Id
enum CoNewExamineRouter {
    case list([String:Any])
    case agree(String,[String:Any])
    case reject(String,[String:Any])
    case nextApver(String)
    
    //NewOBT -------
    case approvalList([String:Any]) //GET /api/v2/approvelist/app/list
    
    case approvalDetail([String:Any])//GET /api/v2/approvelist/detail
    
    case approvalAgree([String:Any]) //172.17.21.75:tbi-obt-approve-api:7082 //POST /api/v1/approve/agree
    
    
    case approvalReject([String:Any]) //POST /api/v1/approve/reject
}
extension CoNewExamineRouter:TargetType{
    /// 请求的基础路径
    var baseURL:URL {return URL(string: "\(BASE_URL)")!}
    /// 拼接路径
    var path:String{
        switch self {
        case .list:
            return "/company/new_approvals/lite"
        case .agree(let id,_):
            return "/company/new_approvals\(id)/agree"
        case .reject(let id,_):
            return "/company/new_approvals\(id)/reject"
        case .nextApver(let id):
            return "/company/new_approvals\(id)/next_apver"
        case .approvalList:
            return "/tbi-obt-order-api/api/v2/approvelist/app/list"
        case .approvalDetail:
            return "/tbi-obt-order-api/api/v2/approvelist/detail"
        case .approvalAgree:
            return "/tbi-obt-approve-api/api/v1/approve/agree"
        case .approvalReject:
            return "/tbi-obt-approve-api/api/v1/approve/reject"
        }
    }
    /// 请求方法
    var method:Moya.Method{
        switch self {
        case .list,.nextApver,.approvalList,.approvalDetail:
            return .get
        case .agree,.reject:
            return .patch
        case .approvalAgree,.approvalReject:
            return .post
        }
    }
    /// 请求参数
    var parameters:[String:Any]?{
        switch self {
        case .list(let params),.agree(_,let params),
             .reject(_,let params),.approvalList(let params),
             .approvalReject(let params),.approvalAgree(let params),.approvalDetail(let params):
            return params
        case .nextApver:
            return nil
        }
    }
    /// 请求参数的发送方式
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .list,.nextApver,.approvalList,.approvalDetail:
            return TokenURLEncoding.default
        case .agree,.reject,.approvalAgree,.approvalReject:
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
