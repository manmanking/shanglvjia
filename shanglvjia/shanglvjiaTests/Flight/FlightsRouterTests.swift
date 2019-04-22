//
//  FlightsRouterTests.swift
//  shanglvjia
//
//  Created by akrio on 2017/4/24.
//  Copyright © 2017年 TBI. All rights reserved.
//

import XCTest
import Moya
import RxSwift
import SwiftyJSON
import SwiftDate
@testable import shanglvjia

class FlightsRouterTests: XCTestCase,CaseConfig {
    
    override func setUp() {
        super.setUp()
        //        BASE_URL = "http://172.17.18.124:8080/api/v1"
        let expectation = self.expectation(description: "登录个人用户 - service")
        let bag = DisposeBag()
        let form  = PersonalLoginUserForm(userName: "18630857599", passWord: "Aa111111")
        UserService.sharedInstance
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
        
    }

    /// 获取航班列表
    func testRouterFlightList(){
        let expectation = self.expectation(description: "获取航班列表 - router")
        let provider = RxMoyaProvider<FlightsRouter>()
        let bag = DisposeBag()
        let form = [
            "departCityCode":"BJS",
            "arriveCityCode":"DLU",
            "departDate":"2017-11-25"
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
    /// 预订机票单程
    func testRouterFlightCommit1(){
        BASE_URL = "http://localhost:8081/api/v1"
        let expectation = self.expectation(description: "预订机票 - router")
        let provider = RxMoyaProvider<FlightsRouter>()
        let bag = DisposeBag()
        let userService = UserService.sharedInstance
        let flightService = FlightService.sharedInstance
        //登录表单
        let loginForm = PersonalLoginUserForm(userName: "18630857599", passWord: "18630857599")
        //查询机票表单
        let searchDate = (DateInRegion() + 1.day).string(custom: "YYYY-MM-dd")
        let flightSearchForm = FlightSearchForm(departCityCode: "SHA", arriveCityCode: "TSN", departDate:searchDate)
        let loginObserable = userService.personalLogin(loginForm)
        let flightSearchObserable = flightService.search(flightSearchForm)
        Observable.combineLatest(loginObserable,flightSearchObserable).map{user,flight -> Observable<Response> in
            let form:[String : Any] = [
                "passengers":[["name":"张三",
                               "cardType":"1",
                               "cardNo":"11"]],
                "orderContact":["contactEmail":"11@qq.com",
                                "contactPhone":"123123213",
                                "contactName":"2312321"
                ],
                "orderTotalAmount":flight.flightList[0].cabinList[0].price+50,
                "searchVo":["departCityCode":flightSearchForm.departCityCode,
                            "arriveCityCode":flightSearchForm.arriveCityCode,
                            "departDate":flightSearchForm.departDate,
                            "departCabinId":flight.flightList[0].cabinList[0].id
                ]
            ]
            return provider
                .request(.commit(form))
            
            }.concat().subscribe{ event in
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
    /// 预订机票单程多航段
    func testRouterFlightCommit2(){
        BASE_URL = "http://localhost:8081/api/v1"
        let expectation = self.expectation(description: "预订机票 - router")
        let provider = RxMoyaProvider<FlightsRouter>()
        let bag = DisposeBag()
        let userService = UserService.sharedInstance
        let flightService = FlightService.sharedInstance
        //登录表单
        let loginForm = PersonalLoginUserForm(userName: "18630857599", passWord: "18630857599")
        //查询机票表单
        let searchDate = (DateInRegion() + 1.day).string(custom: "YYYY-MM-dd")
        let flightSearchForm = FlightSearchForm(departCityCode: "BJS", arriveCityCode: "TSN", departDate:searchDate)
        let loginObserable = userService.personalLogin(loginForm)
        let flightSearchObserable = flightService.search(flightSearchForm)
        Observable.combineLatest(loginObserable,flightSearchObserable).map{user,flight -> Observable<Response> in
            let form:[String : Any] = [
                "passengers":[["name":"张三",
                               "cardType":"1",
                               "cardNo":"11"]],
                "orderContact":["contactEmail":"11@qq.com",
                                "contactPhone":"123123213",
                                "contactName":"2312321"
                ],
                "orderTotalAmount":flight.flightList[0].cabinList[0].price,
                "searchVo":["departCityCode":flightSearchForm.departCityCode,
                            "arriveCityCode":flightSearchForm.arriveCityCode,
                            "departDate":flightSearchForm.departDate,
                            "departCabinId":flight.flightList[0].cabinList[0].id
                ]
            ]
            return provider
                .request(.commit(form))
            
            }.concat().subscribe{ event in
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
