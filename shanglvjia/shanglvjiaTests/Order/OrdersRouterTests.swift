//
//  OrdersRouterTests.swift
//  shanglvjia
//
//  Created by akrio on 2017/5/12.
//  Copyright © 2017年 TBI. All rights reserved.
//

import XCTest
import Moya
import RxSwift
import SwiftyJSON
import SwiftDate
@testable import shanglvjia

class OrdersRouterTests: XCTestCase,CaseConfig {
    override func setUp() {
        super.setUp()
        //        BASE_URL = "http://172.17.18.124:8080/api/v1"
        let expectation = self.expectation(description: "登录个人用户 - service")
        let bag = DisposeBag()
        let form  = PersonalLoginUserForm(userName: "18630857599", passWord: "Aa111111")
        UserService.sharedInstance
            .personalLogin(form)
            .subscribe{ event in
                if case .next(let e) = event {
                    UserDefaults.standard.set(e, forKey: TOKEN_KEY)
                    expectation.fulfill()
                }
                if case .error(let e) = event {
                    print("=====失败======")
                    print(e)
                    expectation.fulfill()
                }
            }.disposed(by: bag)
        
        waitForExpectations(timeout: timeout){ error in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
        
    }
    
    /// 获取订单列表
    func testList(){
        let expectation = self.expectation(description: "获取订单 - router")
        let provider = RxMoyaProvider<OrdersRouter>()
        let bag = DisposeBag()
        let form:[String:Any] = [
            "pageIndex":1,
            "pageSize":5
        ]
        provider
            .request(.list(form))
            .debug()
            .subscribe{ event in
                if case .next(let e) = event {
                    print(JSON(data: e.data))
                    expectation.fulfill()
                }
                if case .error(let e) = event {
                    print(e)
                    expectation.fulfill()
                }
            }.disposed(by: bag)
        
        waitForExpectations(timeout: timeout){ error in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }
    /// 获取个人机票订单详情
    func testFlightDetail(){
        let expectation = self.expectation(description: "获取个人机票订单详情 - router")
        let provider = RxMoyaProvider<OrdersRouter>()
        let bag = DisposeBag()
        // 往返程 多航段 120160706101089
        // 单程 单航段 120170627103617
        provider
            .request(.flight(orderNo: "120170821103665"))
            .debug()
            .subscribe{ event in
                if case .next(let e) = event {
                    print(JSON(data: e.data))
                    expectation.fulfill()
                }
                if case .error(let e) = event {
                    print(e)
                    expectation.fulfill()
                }
            }.disposed(by: bag)
        
        waitForExpectations(timeout: timeout){ error in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }
    /// 获取个人酒店订单详情
    func testHotelDetail(){
        let expectation = self.expectation(description: "获取个人酒店订单详情 - router")
        let provider = RxMoyaProvider<OrdersRouter>()
        let bag = DisposeBag()
        provider
            .request(.hotel(orderNo: "220170817103653"))
            .debug()
            .subscribe{ event in
                if case .next(let e) = event {
                    print(JSON(data: e.data))
                    expectation.fulfill()
                }
                if case .error(let e) = event {
                    print(e)
                    expectation.fulfill()
                }
            }.disposed(by: bag)
        
        waitForExpectations(timeout: timeout){ error in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }
}
