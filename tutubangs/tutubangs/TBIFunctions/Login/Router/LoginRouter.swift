//
//  LoginRouter.swift
//  shanglvjia
//
//  Created by manman on 2018/3/28.
//  Copyright © 2018年 TBI. All rights reserved.
//

import Foundation
import Moya

enum LoginRouter {
    case loginSVLoginNoTC(parameters:[String:Any])//POST /api/v2/users/loginNoTC
    case verifyCode(phone:String)//GET /api/v2/users/mobile/{phoneNo}
    case swiftLogin(phone:String,verifyCode:String)//GET /api/v2/users/mobile/check/{phoneNo}/{code}/{fromApp}
    case binding(parameters:[String:Any])//POST /api/v2/users/mobile/binding
    ///新版
    case sendSms(parameters:[String:Any])//GET /api/v2/users/login/sendSms
    case checkSmsCode(parameters:[String:Any])//GET /api/v2/users/login/checkSmsCode
    case bindCert(parameters:[String:Any])//POST /api/v2/users/login/bindCert
    case loginByPwd(parameters:[String:Any])//POST /api/v2/users/loginNoTCV2
    case bindCompanyAccount(parameters:[String:Any])//POST /api/v2/users/login/bindAccount
}
extension LoginRouter : TargetType {
    
    /// 请求的基础路径
    var baseURL:URL {return URL(string: "\(BASE_URL)")!}
    
    /// 拼接路径
    var path:String{
        switch self {
        case .loginSVLoginNoTC:
            return "/tbi-obt-user-api/api/v2/users/loginNoTC"
            
        case .verifyCode(let phone):
            return "/tbi-obt-user-api/api/v2/users/mobile/\(phone)"
        case .swiftLogin(let phone,let verifyCode):
            return "/tbi-obt-user-api/api/v2/users/mobile/check/\(phone)/\(verifyCode)/1"
        case .binding:
            return "/tbi-obt-user-api/api/v2/users/mobile/binding"
        ///新版
        case .sendSms:
            return "/tbi-cus-user-api/api/v2/users/login/sendSms"
        case .checkSmsCode:
            return "/tbi-cus-user-api/api/v2/users/login/checkSmsCode"
        case .bindCert:
            return "/tbi-cus-user-api/api/v2/users/login/bindCert"
        case .loginByPwd:
            return "/tbi-obt-user-api/api/v2/users/loginNoTCV2"
        case .bindCompanyAccount:
            return "/tbi-cus-user-api/api/v2/users/login/bindAccount"
        }
    }
    /// 请求方法
    var method:Moya.Method{
        switch self {
        case .verifyCode,.swiftLogin,.sendSms,.checkSmsCode:
            return .get
        case .loginSVLoginNoTC,.binding,.bindCert,.loginByPwd,.bindCompanyAccount:
            return .post
        }
    }
    /// 请求参数
    var parameters:[String:Any]?{
        switch self {
        case .verifyCode,.swiftLogin:
            return nil
            
        case .loginSVLoginNoTC(let parameters),
             .binding(let parameters),.sendSms(let parameters),
             .checkSmsCode(let parameters),.bindCert(let parameters),
             .loginByPwd(let parameters),.bindCompanyAccount(let parameters):
            return parameters
        }
    }
    /// 请求参数的发送方式
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .verifyCode,.loginSVLoginNoTC,.swiftLogin,.binding,.loginByPwd:
            return JSONEncoding.default
        case .sendSms,.checkSmsCode:
            return URLEncoding.default
        case .bindCert,.bindCompanyAccount:
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
