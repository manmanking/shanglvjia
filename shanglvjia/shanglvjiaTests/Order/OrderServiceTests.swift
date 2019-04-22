//
//  OrderServiceTests.swift
//  shanglvjia
//
//  Created by akrio on 2017/5/13.
//  Copyright © 2017年 TBI. All rights reserved.
//

import XCTest
import Moya
import RxSwift
import SwiftyJSON
import SwiftDate
import MJExtension
@testable import shanglvjia

class OrderServiceTests: XCTestCase,CaseConfig {
    let orderService = OrderService.sharedInstance
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
    func testList() {
        let expectation = self.expectation(description: "获取订单列表 - service")
        let bag = DisposeBag()
        let searchForm = OrderSearchForm(pageIndex: 1, orderType: .flight)
        orderService.search(searchForm).subscribe{ event in
            if case .next(let e) = event {
                print(e)
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
    /// 获取机票订单详情
    func testFlightDetail() {
        let expectation = self.expectation(description: "获取机票订单详情 - service")
        let bag = DisposeBag()
        //往返程 多航段 120160706101089
        //单程 单航段 120160706101089
        orderService.flightDetailBy("120170821103665")
            .subscribe{ event in
            if case .next(let e) = event {
                print(e.orderStatus)
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
    /// 获取酒店订单详情
    func testHotelDetail() {
        let expectation = self.expectation(description: "获取酒店订单详情 - service")
        let bag = DisposeBag()
        orderService.hotelDetailBy("220170630103760")
            .subscribe{ event in
                if case .next(let e) = event {
                    print(e)
                    print(e.costList)
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
    
    /// 获取旅游订单详情
    func testTravelOrderDetail() {
        let expectation = self.expectation(description: "获取旅游订单详情 - service")
        let bag = DisposeBag()
        orderService.travelOrderDetailBy(orderNo: "520170708103880")
            .subscribe{ event in
                if case .next(let e) = event {
                    print("********^_^**获取旅游订单详情********************")
                    print(e)
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
    
    
    
    
    
    
    
    
    
    
    
}





