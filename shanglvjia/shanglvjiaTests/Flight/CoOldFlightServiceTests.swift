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

/// 企业老版机票相关接口测试
class CoOldFlightServiceTests: XCTestCase,CaseConfig {
    let service = CoOldFlightService.sharedInstance
    var cabinId = ""
    var flightId = ""
    override func setUp() {
        
        super.setUp()
        //        BASE_URL = "http://172.17.18.124:8080/api/v1"
        let expectation = self.expectation(description: "登录企业用户 - service")
        let bag = DisposeBag()
        let loginForm  = CompanyLoginUserForm(userName: "lionel", passWord: "TBI1234hehe", companyCode: "cits")
        let loginService = UserService.sharedInstance.companyLogin(loginForm)
        let searchForm = CoFlightForm.Search(takeOffAirportCode: "TSN", arriveAirportCode: "SHA", departureDate: Date() + 4.months , travellerUids: ["5896899"])
        let searchService = CoOldFlightService.sharedInstance.search(searchForm)
        loginService.map { _ in return searchService}.concat().subscribe{ event in
            if case .next(let e) = event {
                self.cabinId = e.flightList.first?.cabinList.first?.id ?? ""
                self.flightId = e.flightList.first?.id ?? ""
                expectation.fulfill()
            }
            }.disposed(by: bag)
        waitForExpectations(timeout: timeout){ error in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
        
    }
    /// 测试企业用户老版航班查询
    func testList(){
        let expectation = self.expectation(description: "企业用户老版航班查询 - service")
        let form = CoFlightForm.Search(takeOffAirportCode: "TSN", arriveAirportCode: "SHA", departureDate: Date(), travellerUids: ["5896899"])
        let bag = DisposeBag()
        service.search(form).subscribe{ event in
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
    /// 测试企业用户老版生成订单
    func testCreate(){
        let expectation = self.expectation(description: "企业用户老版生成订单 - service")
        let passengerform = CoOldFlightForm.Create.Passenger(uid: "1800187", mobile: "21312323", birthday: "2011-11-11", gender: .female, depInsurance: false, rtnInsurance: false, depTravelCards: [CoOldFlightForm.Create.Passenger.Card()], certNo: "213", certType: .identityCard)
        let form = CoOldFlightForm.Create(depFlightId: flightId, depCabinId: cabinId, linkmanName: "dsa", linkmanMobile: "23123123", linkmanEmail: "12312@21.com", passangers: [passengerform])
        let bag = DisposeBag()
        service.create(form).subscribe{ event in
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
