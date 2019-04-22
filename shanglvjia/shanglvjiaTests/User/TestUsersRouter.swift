//
//  TestUsersRouters.swift
//  shanglvjia
//
//  Created by akrio on 2017/4/19.
//  Copyright © 2017年 TBI. All rights reserved.
//

import XCTest
import Moya
import RxSwift
import SwiftyJSON
@testable import shanglvjia

class TestUsersRouters: XCTestCase,CaseConfig {
    override func setUp() {
        super.setUp()
        //oldLogin()
        loginSVNOTC()
        
    }
    
    func loginSVNOTC() {
        
        let expectation = self.expectation(description: "登录 - service")
        let bag = DisposeBag()
        let loginInfo:LoginSVModel = LoginSVModel()
        loginInfo.fromApp = "1"
        loginInfo.password = DEBUG_Account_Password
        loginInfo.userName = DEBUG_Account
        _ = UserService.sharedInstance
            .loginSVLoginNoOBT(loginInfo)
            .subscribe{ event in
                switch event {
                case .next(let e):
                    printDebugLog(message: e.mj_keyValues())
                case .error(let e):
                    printDebugLog(message: e)
                    
                case .completed:
                    printDebugLog(message: "completed")
                }
                
                
            }.disposed(by: bag)
        
        waitForExpectations(timeout: timeout){ error in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
        
    }
    
    func oldLogin() {
        //        let expectation = self.expectation(description: "登录个人用户 - service")
        //        let bag = DisposeBag()
        //        let form  = PersonalLoginUserForm(userName: "18630857599", passWord: "18630857599")
        //        UserService.sharedInstance
        //            .personalLogin(form)
        //            .subscribe{ event in
        //                if case .next(let e) = event {
        //                    UserDefaults.standard.set(e, forKey: TOKEN_KEY)
        //                    expectation.fulfill()
        //                }
        //                if case .error(let e) = event {
        //                    print("=====失败======")
        //                    print(e)
        //                    expectation.fulfill()
        //                }
        //            }.disposed(by: bag)
        //
        //        waitForExpectations(timeout: timeout){ error in
        //            if let e = error {
        //                XCTFail(e.localizedDescription)
        //            }
        //        }
        
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
    
    
    /// 获取验证码
    func testRouterCode(){
        let expectation = self.expectation(description: "获取验证码 - router")
        let provider = RxMoyaProvider<UsersRouter>()
        let bag = DisposeBag()
        provider
            .request(.verificationCode(tel: "18630857599",parameters:["type":"register"]))
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
    
    /// 注册用户
    func testRouterRegister(){
        let expectation = self.expectation(description: "注册用户 - router")
        let provider = RxMoyaProvider<UsersRouter>()
        let bag = DisposeBag()
        provider
            .request(.register(parameters: ["userName":"18630857599","passWord":"18630857599","verifyCode":"417956"]))
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
    /// 登录个人用户
    func testRouterPersonalLogin(){
        let expectation = self.expectation(description: "登录个人用户 - router")
        let provider = RxMoyaProvider<UsersRouter>()
        let bag = DisposeBag()
        provider
            .request(.personalLogin(parameters: ["userName":"15321802998","passWord":"1234567"]))
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
    /// 登录企业用户
    func testRouterCompanyLogin(){
        let expectation = self.expectation(description: "登录企业用户 - router")
        let provider = RxMoyaProvider<UsersRouter>()
        let bag = DisposeBag()
        provider
            .request(.companyLogin(parameters: ["userName":"testliu","passWord":"Aa111111","companyCode":"newobt"]))
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
    
    
    
    /// 个人绑定企业用户
    func testRouterPersonBindCompany(){
        let expectation = self.expectation(description: "个人绑定企业用户 - router")
        let provider = RxMoyaProvider<UsersRouter>()
        let bag = DisposeBag()
        provider
            .request(.personBindCompany(parameters: ["userName":"lionel","passWord":"TBI1234hehe","companyCode":"cits","id":"298"]))
            .debugHttp()
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
    
    /// 企业用户绑定个人
    func testRouterCompanyBindPerson(){
        let expectation = self.expectation(description: "企业用户绑定个人 - router")
        let provider = RxMoyaProvider<UsersRouter>()
        let bag = DisposeBag()
        let form = ["userName":"18630857599",
                    "passWord":"18630857599",
                    "verifyCode":"219045",
                    "parId":"5896899",
                    "accountId":"2c909e494dddb973014df697389c0914",
                    "companyCode":"newobt",
                    "companyName":""
        ]
        provider
            .request(.companyBindPerson(parameters: form))
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
    
    /// 账号登出
    func testRouterLogout(){
        UserDefaults.standard.set("277_7c273c3e9f90445983e6e3922cf52f0f", forKey: TOKEN_KEY)
        let expectation = self.expectation(description: "账号登出 - router")
        let provider = RxMoyaProvider<UsersRouter>()
        let bag = DisposeBag()
        provider
            .request(.logut())
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
    
    /// 修改用户密码
    func testRouterModifyPassword(){
        let expectation = self.expectation(description: "修改用户密码 - router")
        let user = ["userName":"18630857599","passWord":"18630857599","verifyCode":"123"]
        let provider = RxMoyaProvider<UsersRouter>()
        let bag = DisposeBag()
        provider
            .request(.modifyPassword(parameters: user))
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
    /// 获取用户详细信息
    func testRouterUserDetail(){
//        BASE_URL = "http://localhost:3000"
        let expectation = self.expectation(description: "获取用户详细信息 - router")
        let provider = RxMoyaProvider<UsersRouter>()
        let bag = DisposeBag()
        provider
            .request(.detail(id: "275"))
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
    
    func testFeedBack() {
        let expectation = self.expectation(description: "测试个人版意见反馈 - router")
        let feedback = ["id":"aaaa","contact":"wwewe","opinion":"qweqw"]
        let provider = RxMoyaProvider<FeedBackRouter>()
        let bag = DisposeBag()
        provider
            .request(.feedback(parameters: feedback))
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
}
