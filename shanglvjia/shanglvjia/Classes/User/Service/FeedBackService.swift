//
//  FeedBackService.swift
//  shop
//
//  Created by zhanghao on 2017/7/10.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import SwiftyJSON


final class FeedBackService{
    static let sharedInstance = FeedBackService()
    private init() {}
}

extension FeedBackService : Validator {
    func feedback(_ form:FeedBackVO) -> Observable<Bool> {
        let provider = RxMoyaProvider<FeedBackRouter>()
        //验证手机号填写是否正确
        guard form.contact.validate(.phone) else {
            return validateMessageObservable("common.validate.phone.message")
        }
        guard form.opinion.isNotEmpty else {
            return validateMessageObservable("common.validate.isempty.message","意见信息")
        }
        
        return provider.request(.feedback(parameters: form.toDict()))
            .debugHttp(true)
            .validateResponse()
            .map{_ in true }
    }
    
    func companyfeedback(_ form:CoFeedBackVO) -> Observable<Bool> {
        let provider = RxMoyaProvider<FeedBackRouter>()
        return provider.request(.companyfeedback(parameters: form.toDict()))
            .debugHttp(true)
            .validateResponse()
            .map{_ in true }
    }
}
