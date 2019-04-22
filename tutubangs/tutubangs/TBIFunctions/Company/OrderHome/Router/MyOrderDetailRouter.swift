//
//  MyOrderDetailRouter.swift
//  shanglvjia
//
//  Created by tbi on 2018/5/11.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import Moya

enum MyOrderDetailRouter {
    case orderDetail(orderNo:String,OrderType:String)//GET /api/v2/orders/personal/flight/{orderNo}
//    case carOrderDetail(orderNo:String)//GET /api/v2/orders/personal/car/{orderNo}

}
extension MyOrderDetailRouter : TargetType{
    /// 请求的基础路径
    var baseURL: URL {
        return URL(string:"\(BASE_URL)/tbi-obt-order-api")!
    }
    /// 拼接路径
    var path: String {
        switch self {
        case .orderDetail(let orderNo,let orderType):
         
            let str = orderType == "1" ? "flight" : orderType == "2" ? "hotel" : orderType == "3" ? "train" : "car"
            return "/api/v2/orders/personal/" + str + "/\(orderNo)"
        }
       
        
       
    }
    /// 请求方法
    var method: Moya.Method {
        switch self {
        case .orderDetail:
           return .get
        }
    }
    /// 请求参数
    var parameters: [String : Any]? {
        switch self {
        case .orderDetail:
            return nil
      
        }
    }
     /// 请求参数的发送方式
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .orderDetail:
            return TokenURLEncoding.default
        
        }
    }
    /// 单元测试所需
    var sampleData: Data {
        return Data()
    }
     /// 请求类型 如普通请求，发送文件，下载文件
    var task: Task {
        return .request
    }
    
    
}
