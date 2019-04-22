//
//  NoticeRouter.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/6/20.
//  Copyright © 2017年 TBI. All rights reserved.
//
import Moya
import UIKit


//   .list   获取通知列表


enum CoNoticeRouter {
    case list
}
extension CoNoticeRouter:TargetType{
    /// 请求的基础路径    GET /api/v1/company/notices
    var baseURL:URL {return URL(string: "\(BASE_URL)/company/notices")!}
    /// 拼接路径
    var path:String
    {
        switch self
        {
            case .list:
                return ""
        }
    }
    /// 请求方法
    var method:Moya.Method{
        switch self {
        case .list:
            return .get
        }
    }
    /// 请求参数
    var parameters:[String:Any]?
    {
        switch self
        {
            case .list:
                return nil
        }
    }
    /// 请求参数的发送方式
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .list:
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
