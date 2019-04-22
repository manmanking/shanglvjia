//
//  TravelRouterTests.swift
//  shanglvjia
//
//  Created by akrio on 2017/6/27.
//  Copyright © 2017年 TBI. All rights reserved.
//

import XCTest
import Moya
import RxSwift
import SwiftyJSON
import SwiftDate
@testable import shanglvjia

class TravelRouterTests: XCTestCase,CaseConfig {
    
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
    
    /// 旅游列表
    func testList(){
        let expectation = self.expectation(description: "获取旅游列表 - router")
        let provider = RxMoyaProvider<TravelRouter>()
        let bag = DisposeBag()
        let form:[String:Any] = [
            "pageIndex":1,
            "limit":5,
            "region" : 1
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
    /// 获取特价产品价格列表信息
    func testPrice(){
        let expectation = self.expectation(description: "获取特价产品价格列表信息 - router")
        let provider = RxMoyaProvider<TravelRouter>()
        let bag = DisposeBag()
        let form:[String:Any] = [
            "specialProductsCategoryId":"103",
            "saleDate":"2017-11"
        ]
        provider
            .request(.price(id: "", categoryId: "", form))
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
}
