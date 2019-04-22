//
//  CoNewOrderService.swift
//  shanglvjia
//
//  Created by akrio on 2017/5/15.
//  Copyright © 2017年 TBI. All rights reserved.
//

import XCTest
import Moya
import RxSwift
import SwiftyJSON
import SwiftDate
import MJExtension
@testable import shanglvjia

class CoNewOrderServiceTests: XCTestCase,CaseConfig {
    let orderService = CoNewOrderService.sharedInstance
    override func setUp() {
        super.setUp()
        let expectation = self.expectation(description: "登录企业用户 - service")
        let bag = DisposeBag()
        let form  = CompanyLoginUserForm(userName: "testliu", passWord: "Aa111111", companyCode: "newobt")
        UserService.sharedInstance
            .companyLogin(form)
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
    /// 获取自定义字段
    func testCustom() {
        let expectation = self.expectation(description: "获取自定义字段 - service")
        let bag = DisposeBag()
        orderService.getCustomConfigBy().subscribe{ event in
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
    /// 获取订单详情
    func testDetail() {
        let expectation = self.expectation(description: "获取订单详情 - service")
        let bag = DisposeBag()
        //1000001502
        orderService.getDetailBy("1000002468").subscribe{ event in
            if case .next(let e) = event {
                print(e)
                var ids:[String] = []
                ids += e.flightItems.map{ $0.passengers.map{ $0.id } }.flatMap{ $0 }
                ids += e.hotelItems.map{ $0.passengers.map{ $0.id } }.flatMap{ $0 }
                let distinct = ids.distinct()
                print(distinct)
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
    /// 获取订单状态
    func testState() {
        let expectation = self.expectation(description: "获取订单状态 - service")
        let bag = DisposeBag()
        orderService.getDetailBy("1000001502").subscribe{ event in
            if case .next(let e) = event {
                print(try!e.getStates())
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
        let searchForm = CoNewOrderSearchFrom()
        
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
    /// 获取订单各级审批人信息
    func testManagers() {
        let expectation = self.expectation(description: "获取订单各级审批人信息 - service")
        let bag = DisposeBag()
        orderService.getManagers("1000001865").subscribe{ event in
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
    
    /// 删除机票小订单
    func testCancelFlightOrder() -> Void
    {
        let expectation = self.expectation(description: "删除机票小订单 - service")
        let bag = DisposeBag()
        
        orderService.cancelFlightOrder(orderNo: "1000001546", flightOrderNo: "1000000942").subscribe{event in
        
            if case .next(let e) = event
            {
                print(e.flightItems.first?.state)
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
    
    /// 删除酒店小订单
    func testCancelHotelOrder() -> Void
    {
        let expectation = self.expectation(description: "删除酒店小订单 - service")
        let bag = DisposeBag()
        
        orderService.cancelHotelOrder(orderNo: "", hotelOrderNo: "").subscribe{event in
            
            if case .next(let e) = event
            {
                print(e.hotelItems.first?.state)
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






