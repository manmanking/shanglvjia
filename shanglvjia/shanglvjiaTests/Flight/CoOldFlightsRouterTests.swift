//
//  CoFlightsRouter.swift
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

class CoOldFlightsRouterTests: XCTestCase,CaseConfig {
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
        let expectation = self.expectation(description: "获取航班列表 - router")
        let provider = RxMoyaProvider<CoOldFlightsRouter>()
        let bag = DisposeBag()
        
        let form:[String:Any] = [
            "takeOffAirportCode":"TSN",
            "arriveAirportCode":"SHA",
            "departureDate":Int(Date().timeIntervalSince1970)*1000,
            "type":0,
            "travellerUids":"1800187"
        ]
        provider
            .request(.list(form))
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
    /// 测试企业用户老版机票预定
    func testCommit(){
        let expectation = self.expectation(description: "机票预定 - router")
        let provider = RxMoyaProvider<CoOldFlightsRouter>()
        let bag = DisposeBag()
        //初始化预定表单
        let form:[String:Any] = [
            "depFlightId":flightId,
            "depCabinId":cabinId,
            "linkmanName":"张三",
            "linkmanMobile":"18630958677",
            "linkmanEmail":"123123@qq.com",
            "passangers":[[
                "uid":"1800187",
                "mobile":"12385394723",
                "birthday":"2015-11-11",
                "gender":"M",
                "depInsurance":false,
                "rtnInsurance":false,
                "depTravelCards":[
                    [
                        "number":"",
                        "supplier":""
                    ]
                ],
                "certNo": "211",
                "certType" : 1,
                ]
            ]
            
        ]
        provider.request(.commit(form))
            .debugHttp(true)
            .subscribe{ event in
            if case .next(let e) = event {
                print("=====finish======")
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
