//
//  TravelServiceTests.swift
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
import MJExtension
@testable import shanglvjia

class TravelServiceTests: XCTestCase,CaseConfig {
    
    let travelService = TravelService.sharedInstance
    let citsService = CitsService.sharedInstance
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


    /// 获取旅游列表
    func testSearch() {
        let expectation = self.expectation(description: "获取旅游列表 - service")
        let bag = DisposeBag()
        let form = TravelForm.Search(pageIndex: 1, pageSize: 20)
        travelService.search(form).subscribe{ event in
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

    /// 获取特价产品价格列表信息
    func testSearchPrice() {
        let expectation = self.expectation(description: "获取特价产品价格列表信息 - service")
        let bag = DisposeBag()
        let form = TravelForm.SpecialPriceSearch(saleDate: "2017-06")
        travelService.searchPrice(id: "", categoryId: "", form).subscribe{ event in
            if case .next(let e) = event {
                print(e.count)
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
    
    /// 获取特价产品价格列表信息
    func testDetail() {
        let expectation = self.expectation(description: "获取产品详情 - service")
        let bag = DisposeBag()
        travelService.detail("tbi_1_21").subscribe{ event in
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
    /// 获取产品类别信息
    func testCategorys() {
        let expectation = self.expectation(description: "获取产品类别 - service")
        let bag = DisposeBag()
        travelService.categorys("tbi_1_21").subscribe{ event in
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
    
    /// 提交 定制化旅游
    func testSubmitCustomTravelForm() {
        let expectation = self.expectation(description: "提交定制化旅游 - service")
        let bag = DisposeBag()
        
        let travelOrderForm = TravelDIYIntentOrder(destination: "北京（目的地）", togetherCount: 3, travelDate: "2017-7-30", travelDays: 5, departureCity: "天津", budget: "1000", specialNeeds: "无特殊需求", customerName: "张三", phoneNum: "15811111111", email: "792@163.com")
        
        travelService.submitCustomTravelForm(travelOrderForm: travelOrderForm).subscribe{ event in
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
    
    func testgetDestinations() {
        let expectation = self.expectation(description: "获取旅游目的地 - service")
        let bag = DisposeBag()
        let form = DestinationsModel(type:"7",departure:"北京", destId: "", keyWord: "")
        citsService.getDestinations(form: form).subscribe{ event in
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


}
