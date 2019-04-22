//
//  NoticesServices.swift
//  shanglvjia
//
//  Created by manman on 2018/3/19.
//  Copyright © 2018年 TBI. All rights reserved.
//

import Foundation
import RxSwift
import Moya
/// 单例
final class NoticesServices {
    static let sharedInstance = NoticesServices()
    private init() {} // 阻止其他对象使用这个类的默认的'()'初始化方法
}

extension  NoticesServices: Validator{
    
    
    
    func getNoticesList() ->Observable<NoticeInfoResponse> {
        let provider = RxMoyaProvider<NoticesRouter>()
        return provider
            .request(.noticesList())
            .validateJustReturn(to: NoticeInfoResponse.self)
        
    }
    
    func getNoticesDetail(id:String) ->Observable<NoticeInfoResponse.TbiNotice> {
        let provider = RxMoyaProvider<NoticesRouter>()
        return provider
            .request(.noticesDetail(id:id))
            .debugHttp(true)
            .validateJustReturn(to: NoticeInfoResponse.TbiNotice.self)
        
    }
    
    
}
