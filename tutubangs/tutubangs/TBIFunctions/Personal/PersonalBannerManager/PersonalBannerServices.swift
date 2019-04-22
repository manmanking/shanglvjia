//
//  Services.swift
//  tutubangs
//
//  Created by manman on 2018/10/12.
//  Copyright © 2018 manman. All rights reserved.
//

import UIKit
import RxSwift
import Moya
import SwiftyJSON

final class PersonalBannerServices {
    static let sharedInstance = PersonalBannerServices()
    private init() {}
}

extension  PersonalBannerServices: Validator{
    
    
    
    public func getPersonalBanner() -> Observable<PersonalBannerModel> {
        let provider = RxMoyaProvider<PersonalBannerRouter>()
        return provider
            .request(.bannerList())
            .debugHttp(true)
            .validateJustReturn(to: PersonalBannerModel.self)
    }
    

}
