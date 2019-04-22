//
//  CoNewFlightServiceTests.swift
//  shanglvjia
//
//  Created by akrio on 2017/5/19.
//  Copyright © 2017年 TBI. All rights reserved.
//

import XCTest
import Moya
import RxSwift
import SwiftyJSON
import SwiftDate
@testable import shanglvjia

class CoNewFlightServiceTests: XCTestCase,CaseConfig {
    let service = CoNewFlightService.sharedInstance
    override func setUp() {
        super.setUp()
        //        BASE_URL = "http://172.17.18.124:8080/api/v1"
        let expectation = self.expectation(description: "登录企业用户 - service")
        let bag = DisposeBag()
        let form  = CompanyLoginUserForm(userName: "testliu", passWord: "Aa111111", companyCode: "newobt")
        UserService.sharedInstance
            .companyLogin(form)
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
    /// 测试企业用户新版航班查询
    func testList(){
        let expectation = self.expectation(description: "企业用户新版航班查询 - service")
        let form = CoFlightForm.Search(takeOffAirportCode: "TSN", arriveAirportCode: "SHA", departureDate: Date(), travellerUids: ["5896899"])
        let bag = DisposeBag()
        service.search(form).subscribe{ event in
            if case .next(let e) = event {
                print(e)
                print(e.flightList.last?.cabinList.last?.type ?? "")
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
