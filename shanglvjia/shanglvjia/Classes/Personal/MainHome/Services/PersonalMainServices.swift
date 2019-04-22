//
//  PersonalMainServices.swift
//  shanglvjia
//
//  Created by manman on 2018/7/27.
//  Copyright © 2018年 TBI. All rights reserved.
//

import Foundation

import RxSwift
import Moya
import SwiftyJSON

final class PersonalMainServices {
    static let sharedInstance = PersonalMainServices()
    private init() {}
}
// MARK: - 签证相关service
extension  PersonalMainServices: Validator{

    func getPersonalMainHomeBanner() ->Observable<[String]> {
        let provider = RxMoyaProvider<PersonalMainRouter>()
        return provider
            .request(.mainHomeBanner())
            .debugHttp(true)
            .validateResponse()
            .map({ (json) -> [String] in
                return json.arrayValue.map{$0.stringValue}
            })
    }
    
    
    
    
}


