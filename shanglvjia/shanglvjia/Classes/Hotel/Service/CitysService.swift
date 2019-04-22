//
//  CitysService.swift
//  shop
//
//  Created by zhanghao on 2017/7/11.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import RxSwift
import Moya

/// 单例
final class CitysService {
    static let sharedInstance = CitysService()
    private init() {} // 阻止其他对象使用这个类的默认的'()'初始化方法
}

extension CitysService: Validator{
    
    func getDistrict(cityId:String) -> Observable<Dictionary<String,String>>{
        let provider = RxMoyaProvider<CitysRouter>()
        return provider
            .request(.citysDistrict(cityId:cityId))
            .debugHttp(true)
            .validateResponse()
            .map{ json in
                return json.arrayValue.reduce(Dictionary<String,String>()){i , e in
                    var result = i
                    for d in e.dictionaryValue.enumerated() {
                        result[d.element.key] = d.element.value.stringValue
                    }
                    return result
                }
            }
    }
    
}
