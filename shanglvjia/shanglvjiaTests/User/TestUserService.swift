//
//  TestUserService.swift
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

class TestUserService: XCTestCase,CaseConfig {
    
    let userService = UserService.sharedInstance
    let hotelService = HotelCompanyService.sharedInstance
    let feedbackService = FeedBackService.sharedInstance
    override func setUp() {
        super.setUp()
        //oldLogin()
        loginSVNOTC()
    }
    
    func oldLogin() {
        let expectation = self.expectation(description: "登录个人用户 - service")
        let bag = DisposeBag()
        let form  = PersonalLoginUserForm(userName: "18137167684", passWord: "1234567")
        userService
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
        
        //        let expectation = self.expectation(description: "登录企业用户 - service")
        //        let bag = DisposeBag()
        //        let form  = CompanyLoginUserForm(userName: "fengtian", passWord: "Aa111111", companyCode: "ftms")
        //        UserService.sharedInstance
        //            .companyLogin(form)
        //            .subscribe{ event in
        //                if case .next(let e) = event {
        //                    print("企业登录\(e)")
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

    }
    
    func loginSVNOTC() {
         let expectation = self.expectation(description: "登录 - service")
         let bag = DisposeBag()
        weak var weakSelf = self
        let loginInfo:LoginSVModel = LoginSVModel() //CompanyLoginUserForm(userName: DEBUG_Account,passWord: DEBUG_Account_Password,companyCode:"1")
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
    
    
    
    
    /// 注册用户
    func testServiceRegister(){
        let expectation = self.expectation(description: "注册用户 - service")
        let bag = DisposeBag()
        let form  = RegisterUserForm(userName: "18630857599", passWord: "Aa111111", verifyCode: "874025")
        userService
            .register(form)
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
    
    /// 登录个人用户
    func testServicePersonLogin(){
        let expectation = self.expectation(description: "登录个人用户 - service")
        let bag = DisposeBag()
        let form  = PersonalLoginUserForm(userName: "18630857599", passWord: "Aa111111")
        userService
            .personalLogin(form)
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
    /// 登录企业用户
    func testServiceCompanyLogin(){
        let expectation = self.expectation(description: "登录企业用户 - service")
        let bag = DisposeBag()
       let form  = CompanyLoginUserForm(userName: "lionel", passWord: "TBI1234hehe", companyCode: "cits")
        userService
            .companyLogin(form)
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
    
    /// 登录企业用户未绑定
    func testServiceCompanyLoginNotBind(){
        let expectation = self.expectation(description: "登录企业用户未绑定 - service")
        let bag = DisposeBag()
        let form  = CompanyLoginUserForm(userName: "fengtian", passWord: "Aa111111", companyCode: "ftms")
        userService
            .companyLogin(form)
            .subscribe{ event in
                if case .next(let e) = event {
                    print("=====成功======")
                    print(e)
                    expectation.fulfill()
                }
                if case .error(let e) = event {
                    print("=====失败======")
                    if let exception = e as? HttpError{
                        if case .companyNotBindUser(_,let user) = exception{
                            print(user)
                        }
                    }else{
                       print(e)
                    }
                    expectation.fulfill()
                }
            }.disposed(by: bag)
        
        waitForExpectations(timeout: timeout){ error in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }
    /// 个人用户绑定企业
    func testServicePersonBindCompany(){
        let expectation = self.expectation(description: "个人用户绑定企业 - service")
        let bag = DisposeBag()
        let form  = PersonBindCompanyForm(userName: "testliu", passWord: "Aa111111", companyCode: "newobt",id:"127")
        userService
            .personBindCompany(form)
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
    
    /// 企业绑定个人用户
    func testServiceCompanyBindPerson(){
        let expectation = self.expectation(description: "企业绑定个人用户 - service")
        let bag = DisposeBag()
        let form  = CompanyBindPersonForm(userName: "18630857599", passWord: "18630857599", verifyCode: "219045", parId: "5896899", accountId: "2c909e494dddb973014df697389c0914", companyCode: "newobt")
        userService
            .companyBindPerson(form)
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
    /// 用户登出
    func testServiceLogout(){
        let expectation = self.expectation(description: "用户登出 - service")
        let bag = DisposeBag()
        userService
            .logout()
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
    /// 用户修改密码
    func testServiceModifyPassword(){
        let expectation = self.expectation(description: "用户修改密码 - service")
        let bag = DisposeBag()
        let form  = ModifyPasswordUserForm(userName: "18630857599", passWord: "18630857599",verifyCode:"526413")
        userService
            .modifyPassword(form)
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
    /// 获取验证码
    func testServiceCode(){
//        BASE_URL = "http://localhost:3000"
        let expectation = self.expectation(description: "获取验证码 - service")
        let bag = DisposeBag()
        userService
            .getverificationCode(tel: "18630857599", type: .login)
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
    
    /// 获取用户详情
    func testServiceGetUserDetal(){
        let expectation = self.expectation(description: "获取用户详情 - service")
        let bag = DisposeBag()
        userService
            .detail("307")
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
    
    /// 获取旅客详情
    func testGetTravelers(){
        let expectation = self.expectation(description: "获取旅客详情 - service")
        let bag = DisposeBag()
        hotelService
            .getTravellersBy(["5694798","5694798"])
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
    
    /// 测试连续请求
    func testServiceMulLink(){
        let expectation = self.expectation(description: "测试连续请求 - service")
        let bag = DisposeBag()
        userService
            .detail("277")
            .map{self.userService.detail($0.id!)}
            .concat()
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
    
    func testFeedBackService() {
        let expectation = self.expectation(description: "测试意见反馈相关的东西 - service")
        let form = FeedBackVO(id: "111", contact: "21213", opinion: "saasda")
        let bag = DisposeBag()
        feedbackService.feedback(form)
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
    
    func testHotLineService() {
        let expectation = self.expectation(description: "测试意见反馈相关的东西 - service")
        let form = HotLineRequest(userName: "13312196087")
        let bag = DisposeBag()
        userService.getHotLine(form)
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
