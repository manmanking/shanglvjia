//
//  shanglvjiaTests.swift
//  shanglvjiaTests
//
//  Created by TBI on 2017/4/5.
//  Copyright © 2017年 TBI. All rights reserved.
//

import XCTest
import Moya
import RxSwift
import SwiftyJSON
@testable import shanglvjia

class shanglvjiaTests: XCTestCase {
    
    /// 请求列表
    func testServiceList(){
        let expectation = self.expectation(description: "请求列表 - router")
        let service = DemoService.sharedInstance
        let bag = DisposeBag()
        service
            .getList(page: 10)
            .subscribe{ event in
                if case .next(let e) = event {
                    print(e)
                    expectation.fulfill()
                }
            }.addDisposableTo(bag)
        waitForExpectations(timeout: 10000){ error in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }
    
    /// 请求详情
    func testServiceDetail(){
        let expectation = self.expectation(description: "请求详情 - service")
        let service = DemoService.sharedInstance
        let bag = DisposeBag()
        service
            .getDetailBy("213123")
            .subscribe{ event in
                if case .next(let e) = event {
                    print(e)
                    expectation.fulfill()
                }
            }.addDisposableTo(bag)
        waitForExpectations(timeout: 10000){ error in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }
    
    /// 请求详情变更数据
    func testServiceNames(){
        let expectation = self.expectation(description: "获取用户所有姓名 - service")
        let service = DemoService.sharedInstance
        let bag = DisposeBag()
        service
            .getList(page: 10)
            .map{ user in
                return user.map{return $0.name}
            }.subscribe{ event in
                if case .next(let e) = event {
                    print(e)
                    expectation.fulfill()
                }
            }.addDisposableTo(bag)
        waitForExpectations(timeout: 10000){ error in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }
    
    /// 请求删除
    func testServiceDelete(){
        let expectation = self.expectation(description: "请求删除 - service")
        let service = DemoService.sharedInstance
        let bag = DisposeBag()
        service
            .deleteBy("afadf")
            .subscribe{ event in
                if case .next(let e) = event {
                    print(e)
                    expectation.fulfill()
                }
            }.addDisposableTo(bag)
        waitForExpectations(timeout: 10000){ error in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }
    
    /// 请求更新
    func testServiceUpdate(){
        let expectation = self.expectation(description: "请求更新 - service")
        let service = DemoService.sharedInstance
        let bag = DisposeBag()
        service
            .update("adsf", user: DemoModel.UserPo(name: "aaaa"))
            .subscribe{ event in
                if case .next(let e) = event {
                    print(e)
                    expectation.fulfill()
                }
            }.addDisposableTo(bag)
        waitForExpectations(timeout: 10000){ error in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }
    
    /// 请求添加
    func testServiceCreate(){
        let expectation = self.expectation(description: "请求添加 - service")
        let service = DemoService.sharedInstance
        let bag = DisposeBag()
        service
            .create(DemoModel.UserPo(name: "aaaa"))
            .subscribe{ event in
                if case .next(let e) = event {
                    print(e)
                    expectation.fulfill()
                }
            }.addDisposableTo(bag)
        waitForExpectations(timeout: 10000){ error in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }
    
    /// 求发生错误
    func testServiceError(){
        let expectation = self.expectation(description: "测试请求发生错误 - service")
        let service = DemoService.sharedInstance
        let bag = DisposeBag()
        service
            .create(DemoModel.UserPo(name: "error"))
            .subscribe{ event in
                if case .next(let e) = event {
                    print(e)
                    expectation.fulfill()
                }
                if case .error(let e) = event {
                    print("error")
                    print(e)
                    expectation.fulfill()
                }
            }.addDisposableTo(bag)
        waitForExpectations(timeout: 10000){ error in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }
    
    /// 测试请求发生错误重新请求
    func testServiceErrorRetry(){
        let expectation = self.expectation(description: "测试请求发生错误重新请求 - service")
        let service = DemoService.sharedInstance
        let bag = DisposeBag()
        service
            .create(DemoModel.UserPo(name: "error"))
            .retry(3)//发生错误后从新请求
            .subscribe{ event in
                if case .next(let e) = event {
                    print(e)
                    expectation.fulfill()
                }
                if case .error(let e) = event {
                    print("error")
                    print(e)
                    expectation.fulfill()
                }
            }.addDisposableTo(bag)
        waitForExpectations(timeout: 10000){ error in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }
    
    /// 测试合并多请求
    func testServiceCombine(){
        let expectation = self.expectation(description: "测试合并多请求 - service")
        let service = DemoService.sharedInstance
        let s1 = service.create(DemoModel.UserPo(name: "a"))
        let s2 = service.create(DemoModel.UserPo(name: "a"))
        let bag = DisposeBag()
        Observable.combineLatest(s1,s2){s1,s2 in
             "\(s1) \(s2)"
            }.subscribe{ event in
                if case .next(let e) = event {
                    print(e)
                    expectation.fulfill()
                }
                if case .error(let e) = event {
                    print("error")
                    print(e)
                    expectation.fulfill()
                }
        }.addDisposableTo(bag)
        waitForExpectations(timeout: 10000){ error in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }
    func testLocalizable(){
        print(NSLocalizedString("demo.title", comment: "标题栏"))
    }
}
