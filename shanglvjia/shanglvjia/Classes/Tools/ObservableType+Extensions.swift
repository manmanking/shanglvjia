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
import HandyJSON


// MARK: - 扩展对于网络请求返回数据的验证逻辑
extension ObservableType where E == Response {
    
    /// 打印http请求响应信息
    ///
    /// - Parameter all: 是否全部打印，还是当出错时打印
    /// - Returns: 响应结果不做任何处理
    func debugHttp(_ all:Bool = false) -> Observable<Response> {
        return self.do(onNext: { (response) in
            guard response.statusCode > 300 || all || JSON(data: response.data)["code"].intValue != 100 else {
                return
            }
            if let request = response.request {
                print("request url -> \(request.debugDescription)")
            }else {
                print("request url -> 请求信息缺失")
            }
            if let requestBody = response.request?.httpBody {
                print("request body -> \(String.init(data: requestBody, encoding: String.Encoding.utf8) ?? "解码请求结果失败")")
            }else {
                print("request body -> 请求体信息缺失")
            }
            if let requestHeader = response.request?.allHTTPHeaderFields {
                print("request header -> \(requestHeader)")
            }else {
                print("request header -> 请求头信息缺失")
            }
            if let requestMethod = response.request?.httpMethod {
                print("request method -> \(requestMethod)")
            }else {
                print("request method -> 请求方法缺失")
            }
            print("response status -> \(response.statusCode)")
            print("response body -> \(String.init(data: response.data, encoding: String.Encoding.utf8) ?? "解码响应结果失败")")
        }, onError: { (error) in
            print("请求发生错误 -> \(error)")
        })
    }
    /// 通用验证逻辑
    ///
    /// - Parameter result: response返回的数据
    /// - Returns: 解开包装后的数据
    /// - Throws: 服务器端抛出的异常
    private func validate(_ response:Response) throws -> JSON{
        
        let json = JSON(data:response.data)
        let status = response.statusCode
        if status == 401 {
            throw HttpError.timeout
        }
        guard status < 300 else {
            throw HttpError.serverException(code: status, message: "差旅专家正在抢修中")
        }
        guard json["code"].intValue == 100 else {
            if(json["code"].intValue == 1024){
                throw HttpError.companyNotBindUser(code: 1024, user: CompanyBindPersonForm(json["content"]))
            }
            throw HttpError.serverException(code: json["code"].intValue, message: json["message"].stringValue)
        }
        return json["content"]
        
    }
    private func catchError(e:Swift.Error) throws -> Observable<E>{
        throw MoyaError.requestMapping("aa")
    }
    
   private func validateUpdate(_ response:Response) throws -> Dictionary<String, Any> {
    
//    let test1Json = JSONDecoder.decode(LoginResponse.self,from:response)
    let testJson:Dictionary? =  try JSONSerialization.jsonObject(with: response.data,
    options:.allowFragments) as! [String: Any]
//    if testJson!["content"] != nil {
//    let loginTest = LoginResponse.mj_object(withKeyValues: testJson!["content"])
//    //print(testJson!["code"] as! String)
//    print(loginTest?.mj_keyValues())
//    }
    let json = JSON(data:response.data)
    let status = response.statusCode
    if status == 401 {
        throw HttpError.timeout
    }
    guard status < 300 else {
        throw HttpError.serverException(code: status, message: "差旅专家正在抢修中")
    }
    guard json["code"].intValue == 100 else {
    if(json["code"].intValue == 1024){
        throw HttpError.companyNotBindUser(code: 1024, user: CompanyBindPersonForm(json["content"]))
    }
        throw HttpError.serverException(code: json["code"].intValue, message: json["message"].stringValue)
    }
    return testJson!["content"] as! Dictionary<String, Any>
    }
    
    
    
    
    
    
    //现在写一个替换上面的方法
    //这个不需要转化为JSON 可以减少每个数据结构都要手写解析
    func validateDebug(response:Response) throws ->Response {
        let statusCode = response.statusCode
        switch statusCode {
        case 401:
            throw HttpError.timeout
        case 0...300:
            throw HttpError.serverException(code: statusCode, message: "差旅专家正在抢修中")
        default:
            return response
        }
    }
    
//    func validateJustReturnDebug<T:HandyJSON>(type:T) -> T {
//        return self.map(){
//            let data = self.validateDebug(response: $0)
//            return T.deserialize(from: data)
//
//            } as! T
//    }
    
    /// 验证响应信息是否符合要求，符合要求则返回响应的JSON对象
    ///
    /// - Returns: 返回响应的JSON对象
    func validateResponse()-> Observable<JSON>{
        return self.map{
            let data =  try self.validate($0)
            return data
        }
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
