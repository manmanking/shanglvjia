//
//  JourneyServiceTests.swift
//  shanglvjia
//
//  Created by TBI on 2017/6/15.
//  Copyright © 2017年 TBI. All rights reserved.
//

import XCTest
import Moya
import RxSwift
import SwiftyJSON
import SwiftDate
@testable import shanglvjia

class JourneyServiceTests: XCTestCase,CaseConfig {

    let companyJourneyService = CompanyJourneyService.sharedInstance
    override func setUp() {
        super.setUp()
        let expectation = self.expectation(description: "登录个人用户 - service")
        let bag = DisposeBag()
        let form  = PersonalLoginUserForm(userName: "13821990273", passWord: "13821990273")
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
        let form = JourneySearchForm(startDate: DateInRegion().absoluteDate.unix, dayNum: 365)
        
        companyJourneyService.getList(form)
            
            .subscribe{ event in
            if case .next(let e) = event {
                print(e)
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
