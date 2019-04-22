//
//  SpecialProductTest.swift
//  shanglvjia
//
//  Created by manman on 2017/7/5.
//  Copyright © 2017年 TBI. All rights reserved.
//

import XCTest
import Moya
import RxSwift
import SwiftyJSON
import SwiftDate

@testable import shanglvjia

class SpecialProductTest: XCTestCase,CaseConfig {
    
     let specialProductService =  SpecialProductService.sharedInstance
    
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
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGetList(){

        let expectation = self.expectation(description: "查询特价列表 - service")
        let bag = DisposeBag()
        var searchCondition:SpecialProductListRequestModel = SpecialProductListRequestModel()
        searchCondition.pageIndex = 1
        searchCondition.pageSize = 10
        searchCondition.region = "1"
        specialProductService.getList(form: searchCondition.mj_keyValues() as! Dictionary<String, Any>)
            .subscribe{ event in
                if case .next(let e) = event {
                    print(e)
                }
                if case .error(let e) = event {
                    print("==^_^ ===失败======")
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
    
    func testAdvsRouter(){
        let expectation = self.expectation(description: "获取旅游首页、搜索页面热门线路列表信息 - router")
        let provider = RxMoyaProvider<SpecialRouter>()
        let bag = DisposeBag()
        let form:[String:Any] = [
            "type":"2",
            "departure":"0101"
        ]
        provider
            .request(.advs(form))
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
    
    func testadvsService() {
        let expectation = self.expectation(description: "获取旅游首页、搜索页面热门线路列表信息 - service")
        let bag = DisposeBag()
        let form = AdvsModel(type: "7", departure: "北京")
        SpecialProductService.sharedInstance.advs(form)
            .subscribe{ event in
                if case .next(let e) = event {
                    print("=====成功======")
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
