//
//  UserForm.swift
//  shop
//
//  Created by akrio on 2017/4/19.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import SwiftyJSON
import Moya_SwiftyJSONMapper

/// 注册用户表单实体
struct RegisterUserForm:DictionaryAble {
    /// 用户名
    let userName:String
    /// 密码
    let passWord:String
    /// 验证码
    let verifyCode:String
}

/// 忘记密码的修改用户密码表单实体
struct ModifyPasswordUserForm:DictionaryAble {
    /// 用户名
    let userName:String
    /// 密码
    let passWord:String
    /// 验证码
    let verifyCode:String
}

/// 个人登录用户表单实体
struct PersonalLoginUserForm:DictionaryAble {
    /// 用户名
    let userName:String
    /// 密码
    let passWord:String
}

/// 企业登录用户表单实体
struct CompanyLoginUserForm:DictionaryAble {
    /// 用户名
    let userName:String
    /// 密码
    let passWord:String
    /// 公司码
    let companyCode:String
}

/// 个人用户绑定企业表单实体
struct PersonBindCompanyForm:DictionaryAble {
    /// 企业用户名
    let userName:String
    /// 企业密码
    let passWord:String
    /// 企业公司码
    let companyCode:String
    /// 个人用户id
    let id:String
}

/// 企业绑定个人用户表单实体
struct CompanyBindPersonForm:DictionaryAble {
    /// 个人账号用户名
    var userName:String = ""
    /// 个人账号密码
    var passWord:String = ""
    /// 验证码
    var verifyCode:String = ""
    /// obt个人id
    var parId:String = ""
    /// obt账号id
    var accountId:String = ""
    /// obt公司code
    var companyCode:String = ""
    /// obt公司name
    var companyName:String = ""
    
    init(_ json:JSON) {
        self.parId = json["uid"].stringValue
        self.accountId = json["accountId"].stringValue
        self.companyCode = json["companyCode"].stringValue
    }
    init(userName:String,passWord:String,verifyCode:String,parId:String,accountId:String,companyCode:String,companyName:String = "") {
        self.userName = userName
        self.passWord = passWord
        self.verifyCode = verifyCode
        self.parId = parId
        self.accountId = accountId
        self.companyCode = companyCode
        self.companyName = companyName

    }
}

struct HotLineRequest:DictionaryAble{
    let userName:String?
}


/// 真正的修改用户密码表单实体
struct EditPasswordUserForm:DictionaryAble {
    /// 用户名
    let userName:String
    /// 密码
    let passWord:String
    /// 重复新密码
    let oldPassword:String
}
struct EditPasswordComanyForm:DictionaryAble {
    /// 用户名
    let newPassword:String
    /// 密码
    let newPasswordAgain:String
    /// 重复新密码
    let oldPassword:String
}
//struct HotLineResponse:ALSwiftyJSONAble{
//    let hotLine:String
//    init(jsonData result:JSON){
//        hotLine = result["hotLine"].stringValue
//    }
//}
