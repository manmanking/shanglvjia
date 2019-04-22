//
//  ResponseModel.swift
//  Seed
//
//  Created by akrio on 2017/3/14.
//  Copyright © 2017年 akrio. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON
import Moya_SwiftyJSONMapper
import RxSwift


// MARK: - 扩展对于网络请求返回数据的验证逻辑
extension ObservableType where E == Response {
    /// 通用验证逻辑
    ///
    /// - Parameter result: response返回的数据
    /// - Returns: 解开包装后的数据
    /// - Throws: 服务器端抛出的异常
    private func validate(_ response:Response) throws -> JSON{
        let json = JSON(data:response.data)
        let status = response.statusCode
        print(status)
        guard status < 300 else {
            throw HttpError.serverException(code: status, message: "服务器异常")
        }
        //        guard !result["success"].boolValue else{
        //
        //            throw MoyaError.requestMapping("aa")
        //        }
        return json["content"]
        
    }
    private func catchError(e:Swift.Error) throws -> Observable<E>{
        throw MoyaError.requestMapping("aa")
    }
    /// 验证请求结果，并返回相应结果
    ///
    /// - Parameter type: 返回结果类型 要求实现 ALSwiftyJSONAble 协议
    /// - Returns: 验证后结果的可观察对象
    func validateJustReturn<T: ALSwiftyJSONAble>(to type: T.Type) -> Observable<T> {
        return self.map{
            let data =  try self.validate($0)
            return T(jsonData: data)!
        }
    }
    /// 验证请求结果，并返回相应数组结果
    ///
    /// - Parameter type: 返回数组结果类型 要求数组element实现 ALSwiftyJSONAble 协议
    /// - Returns: 验证后结果的可观察对象
    func validateJustReturn<T: ALSwiftyJSONAble>(to type: [T.Type]) -> Observable<[T]> {
        return self.map{
            let data =  try self.validate($0)
            return data.arrayValue.flatMap{T(jsonData:$0)}
        }
    }
    
}
