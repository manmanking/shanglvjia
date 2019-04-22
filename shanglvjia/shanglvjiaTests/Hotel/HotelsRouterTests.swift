//
//  HotelsRouterTests.swift
//  shanglvjia
//
//  Created by akrio on 2017/4/23.
//  Copyright © 2017年 TBI. All rights reserved.
//

import XCTest
import Moya
import RxSwift
import SwiftyJSON
@testable import shanglvjia

class HotelsRouterTests: XCTestCase,CaseConfig {
    
    override func setUp() {
        super.setUp()
//        BASE_URL = "http://172.17.18.124:8080/api/v1"
    }
    /// 获取热门城市
    func testRouterHotCity(){
        let expectation = self.expectation(description: "获取热门城市 - router")
        let provider = RxMoyaProvider<HotelsRouter>()
        let bag = DisposeBag()
        provider
            .request(.hotCity)
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
    /// 获取酒店列表
    func testRouterList(){
        let expectation = self.expectation(description: "获取酒店列表 - router")
        let provider = RxMoyaProvider<HotelsRouter>()
        let bag = DisposeBag()
        let form = [
            "cityName":"北京",
            "cityId":"0101",
            "arrivalDate":"2017-04-25",
            "departureDate":"2017-04-26",
            "pageIndex":"1",
            "pageSize":"10"
            ]
        provider
            .request(.list(form))
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
    /// 获取城市地标
    func testRouterCityInfo(){
        let expectation = self.expectation(description: " 获取城市地标 - router")
        let provider = RxMoyaProvider<HotelsRouter>()
        let bag = DisposeBag()
        let form = [
            "cityId":"1010"
        ]
        provider
            .request(.cityInfo(form))
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

    /// 获取分公司
    func testRouterFiliale(){
        let expectation = self.expectation(description: " 获取分公司 - router")
        let provider = RxMoyaProvider<HotelsRouter>()
        let bag = DisposeBag()
        let form = [
            "cityName":"天津"
        ]
        provider
            .request(.filiale(form))
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
    
    /// 获取酒店详情
    func testRouterDetail(){
        let expectation = self.expectation(description: " 获取酒店详情 - router")
        let provider = RxMoyaProvider<HotelsRouter>()
        let bag = DisposeBag()
        let form = [
            //"hotelId":"90847112",
            "arrivalDate":"2017-05-13",
            "departureDate":"2017-05-15"
        ]
        provider
            .request(.detail(id:"90847112",parameters: form))
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
    /// 验证信用卡信息
    func testRouterValidateCvv(){
        let expectation = self.expectation(description: " 验证信用卡信息 - router")
        let provider = RxMoyaProvider<HotelsRouter>()
        let bag = DisposeBag()
        provider
            .request(.validateCvv(["cardId":"6259061298906816"]))
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
    
    
    func testCitysRouter() {
        let expectation = self.expectation(description: " 获得城市区域名 - router")
        let provider = RxMoyaProvider<CitysRouter>()
        let bag = DisposeBag()
        provider.request(.citysDistrict(cityId:"0101"))
            .subscribe{ event in
                if case .next(let e) = event {
                    let json = JSON(data: e.data)["content"]
                    let r = json.arrayValue.reduce(Dictionary<String,String>()){i , e in
                        var result = i
                        for d in e.dictionaryValue.enumerated() {
                            result[d.element.key] = d.element.value.stringValue
                        }
                        return result
                    }

                    print(r)
//                    print(JSON(data: e.data))
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
