//
//  PersonalMessageService.swift
//  shanglvjia
//
//  Created by tbi on 05/09/2018.
//  Copyright © 2018 TBI. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON
import RxSwift

final class PersonalMessageService {
    static let sharedInstance = PersonalMessageService()
    private init() {}
}
extension PersonalMessageService:Validator{

    ///
    func getPersonalMessageOrder(pageNo:String) -> Observable<PersonalMessageModel> {
        let requestDic:[String:Any] = ["pageNo":pageNo]
        let provider = RxMoyaProvider<PersonalMessageRouter>()
        return provider
            .request(.personalMessageOrder(requestDic))
            .debugHttp(true)
            .validateJustReturn(to: PersonalMessageModel.self)
    }
    func getPersonalMessageOther(pageNo:String) -> Observable<PersonalMessageModel> {
        let requestDic:[String:Any] = ["pageNo":pageNo]
        let provider = RxMoyaProvider<PersonalMessageRouter>()
        return provider
            .request(.personalMessageOthers( requestDic))
            .debugHttp(true)
            .validateJustReturn(to: PersonalMessageModel.self)
    }
}
