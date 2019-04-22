//
//  NoticeService.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/6/20.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift
import Moya

/// 单例
final class CoNoticeService {
    static let sharedInstance = CoNoticeService()
    private init() {} // 阻止其他对象使用这个类的默认的'()'初始化方法
}

// MARK: - 公告service
extension  CoNoticeService: Validator{
    /// 查询公告列表
    ///
    /// - Parameter : 空
    /// - Returns: 公告列表
    func getNoticeList() -> Observable<[CoNoticeItem]>
    {
        let provider = RxMoyaProvider<CoNoticeRouter>()
        return provider
            .request(.list)
            .debugHttp()
            .validateJustReturn(to: [CoNoticeItem.self])
    }
}
