//
//  PersonalOrderServices.swift
//  shanglvjia
//
//  Created by manman on 2018/8/25.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import RxSwift
import Moya
import SwiftyJSON


/// 单例
final class PersonalOrderServices {
    static let sharedInstance = PersonalOrderServices()
    private init() {} // 阻止其他对象使用这个类的默认的'()'初始化方法
}

// MARK: - 火车票相关service
extension  PersonalOrderServices: Validator{

    
    func orderVisaUploadFileExpressImage(fileName:String) ->Observable<String>{
        let url = URL.init(string: fileName)
        let provider = RxMoyaProvider<PersonalOrderRouter>()
            return provider
                .request(.orderVisaUpload(fileURL:url!))
                .debugHttp(true)
                .validateResponse()
                .map({ (jsonData) -> String in
                    return jsonData.stringValue
                })
    }
    
    func orderVisaUpdateDelivery(deliveryURL:String,orderId:String) ->Observable<JSON> {
        let request:[String:Any] = ["deliveryUrl":deliveryURL,"orderId":orderId]
        let provider = RxMoyaProvider<PersonalOrderRouter>()
        return provider
            .request(.updateDelivery(request))
            .debugHttp(true)
            .validateResponse()
    }
    
    func getOrderCount() ->Observable<String>  {
        let provider = RxMoyaProvider<PersonalOrderRouter>()
        return provider
            .request(.getOrderCount())
            .debugHttp(true)
            .validateResponse()
            .map({ (jsonData) -> String in
                return jsonData.stringValue
            })
    }
    
    func getIntegralDetail(userId:String)->Observable<JSON>{
        let request:[String:Any] = ["userId":userId]
        let provider = RxMoyaProvider<PersonalOrderRouter>()
        return provider
            .request(.getIntegralDetail(request))
            .debugHttp(true)
            .validateResponse()
    }
    
    
    
    


}

