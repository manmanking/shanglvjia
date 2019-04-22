//
//  RouterTest.swift
//  shanglvjia
//
//  Created by akrio on 2017/4/13.
//  Copyright © 2017年 TBI. All rights reserved.
//

import XCTest
import Moya
import RxSwift
import SwiftyJSON
@testable import shanglvjia

class RouterTest: XCTestCase {
    
    func test(){
        let disposeBag = DisposeBag()
        
        Observable.from(["🐶", "🐱", "🐭", "🐹"])
            .subscribe(onNext: { print($0) })
            .addDisposableTo(disposeBag)
    }
    
    func testRouterDelete(){
        let expectation = self.expectation(description: "请求删除 - router")
        let provider = RxMoyaProvider<DemoRouter>()
        let bag = DisposeBag()
        provider
            .request(.delete(id: "adsf"))
            .subscribe{ event in
                if case .next(let e) = event {
                    print(JSON(data: e.data))
                    expectation.fulfill()
                }
                
            }.disposed(by: bag)

        waitForExpectations(timeout: 10000){ error in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }
    
    func testRouterUpdate(){
        let expectation = self.expectation(description: "请求修改 - router")
        let provider = RxMoyaProvider<DemoRouter>()
        let bag = DisposeBag()
        provider
            .request(.update(id:"12231",parameters: ["name": "aaa", "createTime": "2015-11-11"]))
            .subscribe{ event in
                if case .next(let e) = event {
                    print(JSON(data: e.data))
                    expectation.fulfill()
                }
                
            }.disposed(by: bag)
        waitForExpectations(timeout: 10000){ error in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }
    
    func testRouterCreate(){
        let expectation = self.expectation(description: "请求创建 - router")
        let provider = RxMoyaProvider<DemoRouter>()
        let bag = DisposeBag()
        provider
            .request(.create(parameters: ["name": "aaa"]))
            .subscribe{ event in
                if case .next(let e) = event {
                    print(JSON(data: e.data))
                    expectation.fulfill()
                }
                
            }.disposed(by: bag)
        waitForExpectations(timeout: 10000){ error in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }
    
    func testRouterDetail(){
        let expectation = self.expectation(description: "请求详情 - router")
        let provider = RxMoyaProvider<DemoRouter>()
        let bag = DisposeBag()
        provider
            .request(.detail(id: "111"))
            .subscribe{ event in
                if case .next(let e) = event {
                    print(e)
                    expectation.fulfill()
                }
                
            }.disposed(by: bag)
        waitForExpectations(timeout: 10000){ error in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }
    
    func testRouterList(){
        let expectation = self.expectation(description: "请求列表 - router")
        let provider = RxMoyaProvider<DemoRouter>()
        let bag = DisposeBag()
        provider
            .request(.list(page: 1))
            .subscribe{ event in
                if case .next(let e) = event {
                    print(e)
                    expectation.fulfill()
                }
                
            }.disposed(by: bag)
        waitForExpectations(timeout: 10000){ error in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }
}
