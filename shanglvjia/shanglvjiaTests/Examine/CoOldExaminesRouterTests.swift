//
//  CoNewExamineServiceTests.swift
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
@testable import shanglvjia

class CoOldExaminesRouterTests: XCTestCase,CaseConfig {
    override func setUp() {
        super.setUp()
        //        BASE_URL = "http://172.17.18.124:8080/api/v1"
        let expectation = self.expectation(description: "登录企业用户 - service")
        let bag = DisposeBag()
        let form  = CompanyLoginUserForm(userName: "lionel", passWord: "TBI1234hehe", companyCode: "cits")
        UserService.sharedInstance
            .companyLogin(form)
            .subscribe{ event in
                if case .next(let e) = event {
                    print(e)
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
    
    /// 获取审批列表
    func testList(){
        let expectation = self.expectation(description: "获取审批列表 - router")
        let provider = RxMoyaProvider<CoOldExamineRouter>()
        let bag = DisposeBag()
        let form:[String:Any] = [
            "offset":1,
            "limit":5
        ]
        provider
            .request(.list(form))
            .debugHttp(false)
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
    
    /// 获取下级审批人
    func testNextApvId(){
        let expectation = self.expectation(description: "获取审批列表 - router")
        let provider = RxMoyaProvider<CoOldExamineRouter>()
        let bag = DisposeBag()
        provider
            .request(.nextApver("200053600"))
            .debugHttp(true)
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
    
    /// 获取审批订单详情
    func testDetail(){
        let expectation = self.expectation(description: "获取订单详情 - router")
        let provider = RxMoyaProvider<CoOldOrdersRouter>()
        let bag = DisposeBag()
        provider
            .request(.detail("200053461"))
            .debugHttp(false)
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
