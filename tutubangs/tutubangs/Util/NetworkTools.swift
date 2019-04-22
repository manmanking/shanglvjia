//
//  NetworkTools.swift
//  tbiVehicleClient
//
//  Created by TBI on 2017/1/9.
//  Copyright © 2017年 com. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MJExtension

class NetworkTools: SessionManager {
    
    // MARK: 单例
    static let shareInstance: NetworkTools = {
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        
        return NetworkTools(configuration: configuration)
    }()
    
    
    // MARK: 闭包
    typealias ResultCallBack = (_ objc: [String: AnyObject]?, _ error: NSError?) -> ()
    
    
    // MARK: 封装Request方法
    /**
     - parameter method:     请求类型
     - parameter URLString:  请求地址
     - parameter parameters: 请求参数
     - parameter finished:   请求回调
     */
    fileprivate func request(_ url: URLConvertible, method: HTTPMethod, parameters: [String : AnyObject]?, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, finished: @escaping ResultCallBack) {
        // 访问网络
        request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON { (response) in
            
            if response.result.isFailure {
                
                finished(nil, response.result.error as NSError?)
                return
            }
            //把得到的JSON数据转为数组
            if let items = response.result.value as? NSArray{
                //遍历数组得到每一个字典模型
                for dict in items{
                    finished(dict as? [String : AnyObject], nil)
                }
            }
            if let rs = response.result.value as? [String : AnyObject]{
                finished(rs as [String : AnyObject], nil)
            }
            if let ret = response.result.value as? String {
                finished(["ret" : ret as AnyObject], nil)
            }
            
        }
    }
    
    func httpsPost(url: String, param: [String : Any], finished: @escaping (_ objc: [String: AnyObject]?, _ error: NSError?) -> ()) {
        request(url, method: .post, parameters: param as [String : AnyObject]?, encoding:JSONEncoding.default, finished: finished)
    }
    
    func httpsGet(url: String, param: [String : Any], finished: @escaping (_ objc: [String: AnyObject]?, _ error: NSError?) -> ()) {
        request(url, method: .get, parameters: param as [String : AnyObject]?, finished: finished)
    }
    
    
    
}
