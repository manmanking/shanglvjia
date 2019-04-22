//
//  LoginServices.swift
//  shanglvjia
//
//  Created by manman on 2018/3/28.
//  Copyright © 2018年 TBI. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import SwiftyJSON
/// 单例
final class LoginServices{
    static let sharedInstance = LoginServices()
    private init() {} // 阻止其他对象使用这个类的默认的'()'初始化方法
}

extension  LoginServices : Validator{

    //登录
    func loginSVLoginNoOBT(_ form:LoginSVModel) -> Observable<LoginResponse>{
        let provider = RxMoyaProvider<LoginRouter>()
        return provider
            .request(.loginSVLoginNoTC(parameters: form.mj_keyValues() as! [String : Any]))
            .debugHttp(true)
            .validateJustReturn(to: LoginResponse.self)
    }
    

    /// 快捷登录
    func swiftLogin(phone:String,verifyCode:String) -> Observable<LoginResponse> {
        let provider = RxMoyaProvider<LoginRouter>()
        return provider
            .request(.swiftLogin(phone: phone, verifyCode: verifyCode))
            .debugHttp(true)
            .validateResponse()
            .map({ (json) -> LoginResponse in
                return LoginResponse(jsonData:json["loginResponse"]) ?? LoginResponse()
            })
          //  .validateJustReturn(to: LoginResponse.self)
    }
    
    func bindingCompanyAccount(userName:String,corpCode:String,
                               password:String,verifyCode:String,phoneNo:String) -> Observable<LoginResponse>{
        
        let requestDic:Dictionary<String,Any> = ["userName":userName,"password":password,
                                                 "corpCode":corpCode,"phoneNo":phoneNo,
                                                 "code":verifyCode,"fromApp":"1"]
        let provider = RxMoyaProvider<LoginRouter>()
        return provider
            .request(.binding(parameters: requestDic))
            .debugHttp(true)
            .validateResponse()
            .map({ (json) -> LoginResponse in
                return LoginResponse(jsonData:json["loginResponse"]) ?? LoginResponse()
            })
            //.validateJustReturn(to: LoginResponse.self)
        
        
        
    }
    
    /// 获得验证码
    func getVerifyCode(phone:String)->Observable<String> {
        let provider = RxMoyaProvider<LoginRouter>()
        return provider
            .request(.verifyCode(phone: phone))
            .debugHttp(true)
            .validateResponse()
            .map({ (json) -> String in
                return json.stringValue
            })
    }
    
    ///新版
    func getCodeNew(phone:String)->Observable<String>{
        let request:[String:Any] = ["phoneNo":phone]
        let provider = RxMoyaProvider<LoginRouter>()
        return provider
            .request(.sendSms(parameters: request))
            .debugHttp(true)
            .validateResponse()
            .map({ (json) -> String in
                return json.stringValue
            })
    }
    func vertifyCodeNew(request:[String:Any])->Observable<LoginResponse>{
        let provider = RxMoyaProvider<LoginRouter>()
        return provider
            .request(.checkSmsCode(parameters: request))
            .debugHttp(true)
            .validateJustReturn(to: LoginResponse.self)
    }
    ///绑定身份证
    func bindCert(request:[String:Any]) -> Observable<LoginResponse> {
        let provider = RxMoyaProvider<LoginRouter>()
        return provider
            .request(.bindCert(parameters: request))
            .debugHttp(true)
            .validateJustReturn(to: LoginResponse.self)
    }
    ///新版商务账号登陆
    func loginByPwd(request:[String:Any]) -> Observable<LoginResponse> {
        let provider = RxMoyaProvider<LoginRouter>()
        return provider
            .request(.loginByPwd(parameters: request))
            .debugHttp(true)
            .validateJustReturn(to: LoginResponse.self)
    }
    
    
    /// 个人账号 绑定 企业账号
    func personalAccountBindingCompanyAccount(request:BindBusAccountRequest) -> Observable<LoginResponse> {
        let provider = RxMoyaProvider<LoginRouter>()
        return provider
            .request(.bindCompanyAccount(parameters: request.mj_keyValues() as! [String : Any]))
            .debugHttp(true)
            .validateJustReturn(to: LoginResponse.self)
    }
    
}
