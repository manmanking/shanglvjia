//
//  NoticesRouter.swift
//  shanglvjia
//
//  Created by manman on 2018/3/19.
//  Copyright © 2018年 TBI. All rights reserved.
//

import Foundation

import Foundation
import Moya
enum NoticesRouter{
    
    case  noticesList()//GET /api/v2/static/notice
    case  noticesDetail(id:String) //GET /api/v2/static/notice/detail/{id}

}
extension NoticesRouter : TargetType {
    /// 请求的基础路径
    var baseURL:URL {return URL(string: "\(BASE_URL)")!}
    /// 拼接路径
    var path:String{
        switch self {
        case .noticesList:
            return "/tbi-obt-staticinfo-api/api/v2/static/notice"
        case .noticesDetail(let id):
            return "/tbi-obt-staticinfo-api/api/v2/static/notice/detail/\(id)"
            
            
        }
    }
    /// 请求方法
    var method:Moya.Method{
        switch self {
        case .noticesList,.noticesDetail:
            return .get
        }
    }
    /// 请求参数
    var parameters:[String:Any]?{
        switch self {
        case .noticesList,.noticesDetail:
            return nil
        }
    }
    /// 请求参数的发送方式
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .noticesList,.noticesDetail:
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
