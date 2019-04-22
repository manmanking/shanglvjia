//
//  MyOrderDetailService.swift
//  shanglvjia
//
//  Created by tbi on 2018/5/11.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import RxSwift
import Moya

final class MyOrderDetailService{
    static let sharedInstance = MyOrderDetailService()
    private init() {} //阻止其他对象使用这个类的默认的'()'初始化方法
}
extension MyOrderDetailService : Validator{
    /// 查询订单详情
    ///
    /// - Parameter form: 查询条件
    /// - Returns: 机票信息
    func getFlightDetailBy(orderNo:String,orderType:String) -> Observable<OrderDetailModel> {
        let provider = RxMoyaProvider<MyOrderDetailRouter>()
        return provider
            .request(.orderDetail(orderNo:orderNo,OrderType:orderType))
            .debugHttp(true)
            .validateJustReturn(to: OrderDetailModel.self)
    }
    
   
}
