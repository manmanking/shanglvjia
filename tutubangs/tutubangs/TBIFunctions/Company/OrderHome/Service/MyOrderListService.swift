//
//  MyOrderListService.swift
//  shanglvjia
//
//  Created by tbi on 2018/5/10.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import RxSwift
import Moya

final class MyOrderListService {
    static let sharedInstance = MyOrderListService()
    private init() {} // 阻止其他对象使用这个类的默认的'()'初始化方法
}
extension MyOrderListService : Validator
{
    func getOrderList(pageNo:Int,orderStatus:String) -> Observable<MyOrderModel> {
        var request:Dictionary<String,Any> = Dictionary()
        if orderStatus.isEmpty == false {
            request["orderStatus"] = orderStatus
        }
        request["pageNo"] = pageNo
        print("请求信息------\(request)")
        let provider = RxMoyaProvider<MyOrderListRouter>()
        return provider
            .request(.orderList(request))
            .debugHttp(true)
            .validateJustReturn(to: MyOrderModel.self)
        
        
    }
    func scanQrcode(code:String)->Observable<String>{
        let provider = RxMoyaProvider<MyOrderListRouter>()
        return provider
            .request(.scanQRCode(code: code))
            .debugHttp(true)
            .validateResponse()
            .map({ (json) -> String in
                return json.stringValue
            })
    }
}

