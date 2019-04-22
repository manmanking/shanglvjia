//
//  PassengerServices.swift
//  shanglvjia
//
//  Created by manman on 2018/3/16.
//  Copyright © 2018年 TBI. All rights reserved.
//

import Foundation
import RxSwift
import Moya
/// 单例
final class PassengerServices {
    static let sharedInstance = PassengerServices()
    private init() {} // 阻止其他对象使用这个类的默认的'()'初始化方法
}

extension  PassengerServices: Validator{


    
    func getPassengerList(name:String,page:NSInteger) ->Observable<[QueryPassagerResponse]> {
        var request:Dictionary<String,Any> = Dictionary()
        if name.isEmpty == false { request["name"] = name }
        request["pageNo"] = page
        let provider = RxMoyaProvider<PassengerRouter>()
        return provider
            .request(.passengerList(parameters:request))
            .debugHttp(true)
            .validateJustReturn(to: [QueryPassagerResponse.self])
        
    }


}
