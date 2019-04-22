//
//  CodeType.swift
//  shop
//
//  Created by akrio on 2017/4/19.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation

/// 发送验证码类型
///
/// - register: 注册
/// - login: 登录
/// - forgotPassword: 忘记密码
enum CodeType:String {
    case register = "register"
    case login = "login"
    case forgotPassword = "forgot_password"
    case binding = "binding"
}
