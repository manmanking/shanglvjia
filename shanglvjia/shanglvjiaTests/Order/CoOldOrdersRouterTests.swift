//
//  CoNewOrdersRouterTests.swift
//  shanglvjia
//
//  Created by akrio on 2017/5/15.
//  Copyright © 2017年 TBI. All rights reserved.
//
import XCTest
import Moya
import RxSwift
import SwiftyJSON
import SwiftDate
@testable import shanglvjia

class CoOldOrdersRouterTests: XCTestCase,CaseConfig {
    var cabinId:String = ""
    var flightId:String = ""
    override func setUp() {
        super.setUp()
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
    
    /// 获取订单列表
    func testList(){
        let expectation = self.expectation(description: "获取订单列表 - router")
        let provider = RxMoyaProvider<CoOldOrdersRouter>()
        let bag = DisposeBag()
        let form:[String:Any] = [
            "offset":0,
            "limit":5
        ]
        provider
            .request(.list(form))
            .debugHttp(false)
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
    /// 获取订单详情
    func testDetail(){
        let expectation = self.expectation(description: "获取订单详情 - router")
        let provider = RxMoyaProvider<CoOldOrdersRouter>()
        let bag = DisposeBag()
        provider
            .request(.detail("200054136"))
            .debugHttp(false)
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
    /// 订单取消(有问题)
    func testOrderCancel(){
        let expectation = self.expectation(description: "订单取消 - router")
        let provider = RxMoyaProvider<CoOldOrdersRouter>()
        let bag = DisposeBag()
        provider
            .request(.cancelOrder("200053461"))
            .debugHttp(false)
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
    /// 订单转为待定妥(有问题)
    func testOrderConfirm(){
        let expectation = self.expectation(description: "订单转为待定妥 - router")
        let provider = RxMoyaProvider<CoOldOrdersRouter>()
        let bag = DisposeBag()
        provider
            .request(.confirmOrder("200053461"))
            .debugHttp(false)
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
    /// 订单撤回(有问题)
    func testOrderRevoke(){
        let expectation = self.expectation(description: "订单撤回 - router")
        let provider = RxMoyaProvider<CoOldOrdersRouter>()
        let bag = DisposeBag()
        provider
            .request(.revokeOrder("200053461"))
            .debugHttp(false)
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
    /// 生成一张机票订单
    private func createNewOrder() -> Observable<String>{
        let passengerform = CoOldFlightForm.Create.Passenger(uid: "1800187", mobile: "21312323", birthday: "2011-11-11", gender: .female, depInsurance: false, rtnInsurance: false, depTravelCards: [CoOldFlightForm.Create.Passenger.Card()], certNo: "213", certType: .identityCard)
        let form = CoOldFlightForm.Create(depFlightId: flightId, depCabinId: cabinId, linkmanName: "dsa", linkmanMobile: "23123123", linkmanEmail: "12312@21.com", passangers: [passengerform])
        return CoOldFlightService.sharedInstance.create(form)
        
    }
    /// 提交订单
    ///
    /// - Returns: 提交订单的可观察对象
    private func commitOrder() -> Observable<Response>{
        let provider = RxMoyaProvider<CoOldOrdersRouter>()
        var orderNo = ""
        //先生成新订单
        return createNewOrder().map{ orderNoStr  -> Observable<[(key:Int,value:[CoManagerListItem])]> in
            orderNo = orderNoStr
            //获取每级审批人信息
            return CoOldOrderService.sharedInstance.getManagers(orderNo)
            }
            .concat()
            .map{ managers -> Observable<Response> in
                let apverIds = managers.map{ $0.value[0].apverUid }
                return provider
                    .request(.submitOrder(orderNo,[
                        "firstApverId":managers[0].value[0].apverUid,
                        "firstApverName":managers[0].value[0].apverName,
                        "apverIds":apverIds,
                        "purpose":"测试",
                        "description":"测试"
                        ]))
                    .debugHttp(true)
            }
            .concat()
    }
    /// 订单送审
    func testOrderCommit(){
        let expectation = self.expectation(description: "订单送审 - router")
        let bag = DisposeBag()
        //先生成新订单
        commitOrder()
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
    
    /// 获取订单审批人信息
    func testOrderMangers(){
        let expectation = self.expectation(description: "获取订单审批人信息 - router")
        let provider = RxMoyaProvider<CoOldOrdersRouter>()
        let bag = DisposeBag()
        provider
            .request(.managers("200053461"))
            .debugHttp(false)
            .subscribe{ event in
                if case .next(let e) = event {
                    print(JSON(data: e.data))
                    let json = JSON(data: e.data)
                    print(json)
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
