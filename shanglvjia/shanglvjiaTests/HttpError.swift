//
//  HttpError.swift
//  shop
//
//  Created by akrio on 2017/4/14.
//  Copyright © 2017年 zhangwangwang. All rights reserved.
//

import Foundation
enum HttpError:Error{
    case timeout
    case serverException(code:Int,message:String)
}

extension HttpError:CustomStringConvertible{
    var description:String {
        switch self {
        case .timeout:
            return "登录超时"
        case .serverException(let code,let message):
            return "\(code) -> \(message)"
        }
    }
}
