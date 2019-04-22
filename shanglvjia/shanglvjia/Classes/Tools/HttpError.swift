//
//  HttpError.swift
//  shop
//
//  Created by akrio on 2017/4/14.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import RxSwift
/// http请求通用错误
///
/// - timeout: token过期
/// - serverException: 一般服务器异常
/// - companyNotBindUser: 公司没有绑定个人错误
/// - serverTimeout: 服务器超时
enum HttpError:Error{
    case timeout
    case serverException(code:Int,message:String)
    case companyNotBindUser(code:Int,user:CompanyBindPersonForm)
    case serverTimeout
}

extension HttpError:CustomStringConvertible{
    var description:String {
        switch self {
        case .timeout:
            return "token过期 请重新登录"
        case .serverException(let code,let message):
            return "\(code) -> \(message)"
        case .companyNotBindUser(let code,_):
            return "\(code) -> 公司没有绑定个人)"
        case .serverTimeout:
            return "服务器连接超时"
        }
    }
}
protocol Validator {
    
}
extension Validator{
    func validateMessage(_ message:String,_ params:[String]) -> HttpError{
        let errorMessage = String(format: NSLocalizedString(message, comment: ""),arguments:params)
        return HttpError.serverException(code: 9999, message: NSLocalizedString(errorMessage, comment: ""))
    }
    func validateMessage(_ message:String,_ params:String...) -> HttpError{
        let errorMessage = String(format: NSLocalizedString(message, comment: ""),arguments:params)
        return HttpError.serverException(code: 9999, message: NSLocalizedString(errorMessage, comment: ""))
    }
    func validateMessageObservable<E>(_ message:String,_ params:String...) -> Observable<E>{
        return Observable.error(self.validateMessage(message,params))

    }
}
/// 一般异常
///
/// - fail: 严重级别错误
enum Exception:Error {
    case fail(message:String)
}
extension Exception:CustomStringConvertible {
    var description:String {
        switch self {
        case .fail(let message):
            return "页面异常，请您重新尝试"
            //return "错误  -> \(message))"
        }
    }
}
