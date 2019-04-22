//
//  UserService.swift
//  shop
//
//  Created by akrio on 2017/4/19.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import SwiftyJSON
/// 单例
final class UserService{
    static let sharedInstance = UserService()
    private init() {} // 阻止其他对象使用这个类的默认的'()'初始化方法
}

extension  UserService : Validator{
    /// 获取验证码
    ///
    /// - Parameters:
    ///   - tel: 收短信的手机号
    ///   - type: 验证码类型
    /// - Returns: 验证码
    func getverificationCode(tel:String,type:CodeType) -> Observable<String>{
        //验证手机号填写是否正确
        guard tel.validate(.phone) else {
            return validateMessageObservable("common.validate.phone.message" )
        }
        let provider = RxMoyaProvider<UsersRouter>()
        return provider
            .request(.verificationCode(tel: tel, parameters: ["type":type.rawValue]))
            .validateResponse()
            .map{$0.stringValue}
        
    }
    
    func validationCode(tel:String,parameter:[String:Any]) ->Observable<String> {
        let provider = RxMoyaProvider<UsersRouter>()
        return provider.request(.validationCode(tel:tel,parameters: parameter))
            .debugHttp(true)
            .validateResponse()
            .map{$0["message"].stringValue}
        
    }
    
    
    
    
    
    /// 注册用户
    ///
    /// - Parameter form: 用户表单实体
    /// - Returns: 用户token
    func register(_ form:RegisterUserForm) -> Observable<String>{
        let provider = RxMoyaProvider<UsersRouter>()
        return provider
            .request(.register(parameters:form.toDict()))
            .debugHttp(true)
            .validateResponse()
            .map{ json -> Observable<String> in
                let token = "\(json["userId"].stringValue)_\(json["token"].stringValue)"
                UserDefaults.standard.set(token, forKey: TOKEN_KEY)
                let userId = json["userId"].stringValue
                return self.detail(userId).map{ _ -> String in
                    return token
                }
            }
            .concat()
    }
    /// 个人登录
    ///
    /// - Parameter form: 用户表单实体
    /// - Returns: 用户token
    func personalLogin(_ form:PersonalLoginUserForm) -> Observable<String>{
        //验证手机号填写是否正确
        guard form.userName.validate(.phone) else {
            return validateMessageObservable("common.validate.username.message")
        }
        let provider = RxMoyaProvider<UsersRouter>()
        return provider
            .request(.personalLogin(parameters: form.toDict()))
            .validateResponse()
            .map{ json -> Observable<String> in
                let token = "\(json["userId"].stringValue)_\(json["token"].stringValue)"
                UserDefaults.standard.set(token, forKey: TOKEN_KEY)
                let userId = json["userId"].stringValue
                return self.detail(userId).map{ _ -> String in
                    return token
                }
            }
            .concat()
        
       
    }
    /// 企业登录
    ///
    /// - Parameter form: 用户表单实体
    /// - Returns: 用户token
    func companyLogin(_ form:CompanyLoginUserForm) -> Observable<String>{
        let provider = RxMoyaProvider<UsersRouter>()
        return provider
            .request(.companyLogin(parameters: form.toDict()))
            .debugHttp(true)
            .validateResponse()
            .map{ json -> Observable<String> in
                let token = "\(json["userId"].stringValue)_\(json["token"].stringValue)"
                UserDefaults.standard.set(token, forKey: TOKEN_KEY)
                let userId = json["userId"].stringValue
                return self.detail(userId).map{ _ -> String in
                    return token
                }
            }
            .concat()
    }
    
    /// 个人用户绑定企业
    ///
    /// - Parameter form: 用户表单实体
    /// - Returns: 用户信息
    func personBindCompany(_ form:PersonBindCompanyForm) -> Observable<String>{
        let provider = RxMoyaProvider<UsersRouter>()
        return provider
            .request(.personBindCompany(parameters: form.toDict()))
            .debugHttp(true)
            .validateResponse()
            .map{ json -> Observable<String> in
                let token = "\(json["userId"].stringValue)_\(json["token"].stringValue)"
                UserDefaults.standard.set(token, forKey: TOKEN_KEY)
                let userId = json["userId"].stringValue
                return self.detail(userId).map{ _ -> String in
                    return token
                }
            }
            .concat()
    }
    /// 企业绑定个人用户
    ///
    /// - Parameter form: 绑定表单实体
    /// - Returns: token
    func companyBindPerson(_ form:CompanyBindPersonForm) -> Observable<String>{
        let provider = RxMoyaProvider<UsersRouter>()
        return provider
            .request(.companyBindPerson(parameters: form.toDict()))
            .validateResponse()
            .map{ json -> Observable<String> in
                let token = "\(json["userId"].stringValue)_\(json["token"].stringValue)"
                UserDefaults.standard.set(token, forKey: TOKEN_KEY)
                let userId = json["userId"].stringValue
                return self.detail(userId).map{ _ -> String in
                    return token
                }
            }
            .concat()
    }
    /// 用户登出
    ///
    /// - Returns: 是否登出成功
    func logout() -> Observable<Bool>{
        let provider = RxMoyaProvider<UsersRouter>()
        return provider
            .request(.logut())
            .validateResponse()
            .map{_ in
                UserDefaults.standard.set("", forKey: TOKEN_KEY)
                return true
            }
    }
    ///  忘记的修改密码
    ///
    /// - Returns: 是否登出成功
    func modifyPassword(_ form:ModifyPasswordUserForm) -> Observable<Bool>{
        //验证手机号填写是否正确
        guard form.userName.validate(.phone) else {
            return validateMessageObservable("common.validate.phone.message")
        }
        let provider = RxMoyaProvider<UsersRouter>()
        return provider
            .request(.modifyPassword(parameters: form.toDict()))
            .debugHttp(true)
            .validateResponse()
            .map{_ in true }
    }
    /// 获取用户详细信息
    ///
    /// - Parameter id: 用户id
    /// - Returns: 用户信息
    func detail(_ id:String) -> Observable<UserDetail>{
        print("发起detail请求")
        let provider = RxMoyaProvider<UsersRouter>()
        return provider
            .request(.detail(id: id))
            .debugHttp(true)
            .validateResponse()
            .map{ json in
                UserDefaults.standard.set(json.description, forKey: USERINFO)
//                print(json["userName"].stringValue)
//                let userName = json["userName"].stringValue
//                let hotLineRequest = HotLineRequest(userName: userName)
//                self.getHotLine(hotLineRequest)
                return UserDetail(jsonData:json)
            }
        
    }
    
    /// 获取用户详细信息
    ///
    /// - Parameter id: 用户id
    /// - Returns: 用户信息
    func userDetail(_ id:String) -> Observable<UserDetail>{
        guard let details = UserDefaults.standard.string(forKey: USERINFO) else{
            return self.detail(id)
        }
        let jdetails = JSON(parseJSON: details)
        return Observable.just(UserDetail(jsonData:jdetails))
    }
    
    /// 获取用户详细信息
    ///
    /// - Parameter id: 用户id
    /// - Returns: 用户信息
    func userDetail() -> UserDetail?{
        guard let details = UserDefaults.standard.string(forKey: USERINFO) else{
            return nil
        }
        let jdetails = JSON(parseJSON: details)
        return UserDetail(jsonData:jdetails)
    }
    
    
    func getHotLine(_ from:HotLineRequest) -> Observable<[ServicesPhoneModel]> {
        let provider = RxMoyaProvider<UsersRouter>()
        return provider
            .request(.gethotline(parameters: from.toDict()))
            .debugHttp(true)
            .validateJustReturn(to: [ServicesPhoneModel.self])
//            .validateResponse()
//            .map{hotline in
////                print(hotline.description)
//                UserDefaults.standard.set(hotline.description, forKey: HOTLINE)
//                if hotline.description == "null"{
//                    return "缺失"
//                }else{
//                    return hotline.description
//                }
//        }
    }
    
    func editPw(_ form:EditPasswordUserForm) -> Observable<Bool> {
        let provider = RxMoyaProvider<UsersRouter>()
        return provider
        .request(.editpw(parameters: form.toDict()))
            .debugHttp(true)
            .validateResponse()
            .map{_ in true }
    }
    
    //／修改企业密码
    func editCompanyPwd(_ form:EditPasswordComanyForm) -> Observable<CoTrainStatusResultItem> {
        let provider = RxMoyaProvider<UsersRouter>()
        return provider
            .request(.editCompanyPwd(parameters: form.toDict()))
            .debugHttp(true)
            .validateJustReturn(to: CoTrainStatusResultItem.self)
    }
    /// 获取用户详细信息
    ///
    /// - Parameter id: 用户id
    /// - Returns: 用户信息
    func version() -> Observable<Version>{
        let provider = RxMoyaProvider<UsersRouter>()
        return provider.request(.version())
            .debugHttp(true)
            .validateJustReturn(to: Version.self)
    }
    
    //MARK:-------------NEWOBT---------
    /// 企业登录
    ///
    /// - Parameter form: 用户表单实体
    /// - Returns: 用户token
    func loginSVLoginNoOBT(_ form:LoginSVModel) -> Observable<LoginResponse>{
        let provider = RxMoyaProvider<UsersRouter>()
        return provider
            .request(.loginSVLoginNoTC(parameters: form.mj_keyValues() as! [String : Any]))
            .debugHttp(true)
            .validateJustReturn(to: LoginResponse.self)
    }

//
//    func testLoginSVLoginNoOBT(_ form:LoginSVModel) -> Observable<LoginResponse>{
//        let provider = RxMoyaProvider<UsersRouter>()
//        return provider
//            .request(.loginSVLoginNoTC(parameters: form.mj_keyValues() as! [String : Any]))
//            .map(to: [ALSwiftyJSONAble.Protocol])
//
//    }

    
    
    
}
