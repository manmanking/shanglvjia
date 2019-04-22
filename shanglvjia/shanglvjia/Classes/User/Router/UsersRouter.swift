//
//  UsersRouters.swift
//  shop
//
//  Created by akrio on 2017/4/19.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import Moya

enum UsersRouter {
    case verificationCode(tel:String,parameters:[String:Any])
    case validationCode(tel:String,parameters:[String:Any])
    case register(parameters:[String:Any])
    case personalLogin(parameters:[String:Any])
    case companyLogin(parameters:[String:Any])
    case personBindCompany(parameters:[String:Any])
    case companyBindPerson(parameters:[String:Any])
    case logut()
    case modifyPassword(parameters:[String:Any])
    case detail(id:String)
    case gethotline(parameters:[String:Any])
    case editpw(parameters:[String:Any])
    case editCompanyPwd(parameters:[String:Any])
    case version()    
    case loginSVLoginNoTC(parameters:[String:Any])//POST /api/v2/users/loginNoTC
}
extension UsersRouter : TargetType{
    
    /// 请求的基础路径
//    var baseURL:URL {return URL(string: "\(BASE_URL)/tbi-obt-user-api/api/v2/users")!}
    /// 请求的基础路径
    var baseURL: URL {
        switch self {
        case .editCompanyPwd:
            return URL(string: "\(IP_ADD):7071/api/v2/users")!
    case .verificationCode,.validationCode,.register,.personalLogin,.companyLogin,.personBindCompany,.companyBindPerson,.logut,.modifyPassword,.detail,.gethotline,.editpw,.version,.loginSVLoginNoTC:
            return URL(string: "\(BASE_URL)/tbi-obt-user-api/api/v2/users")!
        }
        
    }
    
    /// 拼接路径
    var path:String{
        switch self {
        case .register:
            return "/register"
        case .verificationCode(let tel,_):
            return "/\(tel)/code"
        case .validationCode(let tel,_):
            return "/validation/\(tel)/code"
        case .personalLogin,.logut,.modifyPassword,.editpw:
            return "/"
        case .companyLogin:
           return "/company"
        case .personBindCompany:
            return "/binding"
        case .detail(let id):
            return "/\(id)"
        case .companyBindPerson:
            return "/company/binding"
        case .gethotline:
            return "getHotLineWithPlatform"//"/getHotLine"
        case .version:
            return "/version"
        case .editCompanyPwd:
             return "/editPassword"            
        case .loginSVLoginNoTC:
            return "/loginNoTC"
            
        }
    }
    /// 请求方法
    var method:Moya.Method{
        switch self {
        case .register,.personalLogin,.companyLogin,.personBindCompany,.companyBindPerson,.editCompanyPwd:
            return .post
        case .verificationCode,.detail,.validationCode,.gethotline,.version:
            return .get
        case .logut:
            return .delete
        case .modifyPassword:
            return .patch
        case .editpw:
            return .put            
        case .loginSVLoginNoTC:
            return .post
        }
    }
    /// 请求参数
    var parameters:[String:Any]?{
        switch self {
        case .verificationCode(_,let parameters),.register(let parameters),
             .personalLogin(let parameters),.companyLogin(let parameters),
             .personBindCompany(let parameters),.modifyPassword(let parameters),
             .companyBindPerson(let parameters),.validationCode(_,let parameters),
             .gethotline(let parameters),.editpw(let parameters),.editCompanyPwd(parameters: let parameters):
            return parameters
        case .logut,.detail,.version:
            return nil
        case .loginSVLoginNoTC(let parameters):
            return parameters
        }
    }
    /// 请求参数的发送方式
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .register,.personalLogin,.companyLogin,.companyBindPerson,.modifyPassword,.editpw:
            return JSONEncoding.default
        case .verificationCode,.validationCode,.gethotline:
            return URLEncoding.default
        case .logut,.detail,.version:
            return TokenURLEncoding.default
        case .personBindCompany,.editCompanyPwd:
            return TokenJSONEncoding.default            
        case .loginSVLoginNoTC:
            return JSONEncoding.default
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
