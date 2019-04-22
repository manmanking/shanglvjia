//
//  FlightServiceTests.swift
//  shanglvjia
//
//  Created by akrio on 2017/4/24.
//  Copyright © 2017年 TBI. All rights reserved.
//

import XCTest
import Moya
import RxSwift
import SwiftyJSON
@testable import shanglvjia

class CityServiceTests: XCTestCase,CaseConfig {
    let service = CityService.sharedInstance
    /// 获取城市信息
    func testCities(){
        let expectation = self.expectation(description: "获取城市信息 - service")
        let bag = DisposeBag()
        service.getCities("A",type: .flightAirport).subscribe{ event in
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
    /// 获取城市分组信息
    func testGroup(){
        let expectation = self.expectation(description: "获取城市分组信息 - service")
        let bag = DisposeBag()
        service.getGroups(.flightAirport).subscribe{ event in
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
    
    /// 所有城市相关信息初始化
    func testCityInit(){
        let expectation = self.expectation(description: "所有城市相关信息初始化 - service")
        let bag = DisposeBag()
        service.bufferAllCity().subscribe{ event in
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
