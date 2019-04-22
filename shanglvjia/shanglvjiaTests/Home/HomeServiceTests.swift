//
//  HomeServiceTests.swift
//  shanglvjia
//
//  Created by TBI on 2017/6/12.
//  Copyright © 2017年 TBI. All rights reserved.
//

import XCTest
import Moya
import RxSwift
import SwiftyJSON
import SwiftDate
@testable import shanglvjia

class HomeServiceTests: XCTestCase,CaseConfig {

    let homeService = HomeService.sharedInstance
    override func setUp() {
        super.setUp()
        let expectation = self.expectation(description: "登录个人用户 - service")
        let bag = DisposeBag()
        let form  = PersonalLoginUserForm(userName: "13621186634", passWord: "13621186634")
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
    
    /// 查询首页信息
    func testHomeInfo(){
        let expectation = self.expectation(description: "查询首页信息 - service")
        let bag = DisposeBag()
        homeService.getHomeInfo().subscribe{ event in
            if case .next(let e) = event {
                print(e.iconUrl)
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
