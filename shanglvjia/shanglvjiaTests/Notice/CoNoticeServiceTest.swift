//
//  CoNoticeServiceTest.swift
//  shanglvjia
//
//  Created by 孙祎鸿 on 2017/6/20.
//  Copyright © 2017年 TBI. All rights reserved.
//

import XCTest
import Moya
import RxSwift
import SwiftyJSON
import SwiftDate
@testable import shanglvjia

class CoNoticeServiceTest: XCTestCase,CaseConfig
{
    let coNoticeService = CoNoticeService.sharedInstance
    
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
    
    /// 查询首页信息
    func testGetNoticeList()
    {
        let expectation = self.expectation(description: "查询公告列表 - service")
        let bag = DisposeBag()
        
        coNoticeService.getNoticeList()
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
}
