//
//  PersonalMineService.swift
//  shanglvjia
//
//  Created by tbi on 23/08/2018.
//  Copyright © 2018 TBI. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON
import RxSwift

final class PersonalMineService {
    static let sharedInstance = PersonalMineService()
    private init() {}
}
extension PersonalMineService:Validator{
    ///查询个人信息
    func queryPersonalBaseInfo() -> Observable<PersonalBaseInfoModel>{
        let provider = RxMoyaProvider<PersonalMineRouter>()
        return provider
            .request(.queryPersonalBaseInfo())
            .debugHttp(true)
            .validateJustReturn(to: PersonalBaseInfoModel.self)
    }
    ///维护个人信息
    func bindUserAppend(request:PersonalBaseInfoModel) -> Observable<String> {
        let provider = RxMoyaProvider<PersonalMineRouter>()
        return provider
            .request(.bindUserAppend(request.mj_keyValues() as! [String : Any]))
            .debugHttp(true)
            .validateResponse()
            .map({ (json) -> String in
                return json.stringValue
            })
    }
}
