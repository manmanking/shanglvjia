//
//  Alamofire+Extension.swift
//  shop
//
//  Created by akrio on 2017/4/21.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation

import Alamofire

public struct TokenJSONEncoding: ParameterEncoding {
    // MARK: Properties
    
    /// Returns a `JSONEncoding` instance with default writing options.
    public static var `default`: TokenJSONEncoding { return TokenJSONEncoding() }
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try JSONEncoding.default.encode(urlRequest, with: parameters)
        if request.value(forHTTPHeaderField: "authorization") == nil {
            var token:String = ""
            if DBManager.shareInstance.userDetailDraw() != nil {
                switch DBManager.shareInstance.getCurrentActive() {
                case .Company_Active:
                    token = DBManager.shareInstance.userDetailDraw()?.busLoginInfo.token ?? ""
                case .Personal_Active:
                    token = DBManager.shareInstance.userDetailDraw()?.cusLoginInfo.token ?? ""
                }
            }
            printDebugLog(message: token)
            request.setValue(token, forHTTPHeaderField: "authorization")
        }
        return request
    }
}


public struct TokenURLEncoding: ParameterEncoding {
    
    /// Returns a default `URLEncoding` instance.
    public static var `default`: TokenURLEncoding { return TokenURLEncoding() }
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request =  try URLEncoding.default.encode(urlRequest, with: parameters)
        if request.value(forHTTPHeaderField: "authorization") == nil {
            var token:String = ""
            if DBManager.shareInstance.userDetailDraw() != nil {
                switch DBManager.shareInstance.getCurrentActive() {
                case .Company_Active:
                    token = DBManager.shareInstance.userDetailDraw()?.busLoginInfo.token ?? ""
                case .Personal_Active:
                    token = DBManager.shareInstance.userDetailDraw()?.cusLoginInfo.token ?? ""
                }
            }
            printDebugLog(message: token)
            request.setValue(token, forHTTPHeaderField: "authorization")
        }
        return request
    }
    
}
