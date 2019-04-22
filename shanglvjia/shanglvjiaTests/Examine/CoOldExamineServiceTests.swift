//
//  CoOldExamineServiceTests.swift
//  shanglvjia
//
//  Created by akrio on 2017/5/28.
//  Copyright © 2017年 TBI. All rights reserved.
//

import XCTest
import Moya
import RxSwift
import SwiftyJSON
import SwiftDate
import MJExtension
@testable import shanglvjia

class CoOldExamineServiceTests: XCTestCase,CaseConfig {
    
    let orderService = CoOldOrderService.sharedInstance
    override func setUp() {
        super.setUp()
        let expectation = self.expectation(description: "登录企业用户 - service")
        let bag = DisposeBag()
        let form  = CompanyLoginUserForm(userName: "lionel", passWord: "TBI1234hehe", companyCode: "cits")
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
    /// 获取订单详情
    func testDetail() {
        let expectation = self.expectation(description: "获取订单详情 - service")
        let bag = DisposeBag()
        orderService.getDetailBy("200053600").subscribe{ event in
            if case .next(let e) = event {
                print(e)
                print(e.currentApvId)
                print(e.currentApvLevel)
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

