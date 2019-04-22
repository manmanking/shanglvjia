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

class CoNewOrdersRouterTests: XCTestCase,CaseConfig {
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
    
    /// 获取订单列表
    func testList(){
        let expectation = self.expectation(description: "获取订单列表 - router")
        let provider = RxMoyaProvider<CoNewOrdersRouter>()
        let bag = DisposeBag()
        let form:[String:Any] = [
            "offset":1,
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
        let provider = RxMoyaProvider<CoNewOrdersRouter>()
        let bag = DisposeBag()
        provider
            .request(.detail("1000000711"))
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
    /// 创建一个空出差单
    ///
    /// - Returns: 新建出差单后返回实体
    private func createEmptyOrder() -> Observable<Response>{
        let provider = RxMoyaProvider<CoNewOrdersRouter>()
        return CoNewOrderService.sharedInstance.getCustomConfigBy().map{ result -> Observable<Response> in
            let fields = result.customFields
            var form:[String:Any] = [
                "apvRuleId":"ff8080814dd3bdd0014df6858808020e",
                "costCenterNames":["新版差旅系统-测试新版部"],
                "costCenterIds":["51127"],
                "departureDate":Int(Date().timeIntervalSince1970)*1000,
                "returnDate":Int(Date().timeIntervalSince1970)*1000,
                "purpose":"因公出行",
                "reason":"谈业务",
                "destinations":["北京","上海"],
                "uids":["5896911"]
            ]
            form["opinions"] = fields.map{
                [
                    "id":$0.id,
                    "value":"111",
                    "resultId":$0.resultId
                ]
            }
            return provider.request(.create(form))
            }.concat().debugHttp(true)
    }
    /// 创建出差单
    func testCreate(){
        let expectation = self.expectation(description: "创建出差单 - router")
        //        let form = CreateCoNewOrderFrom(apvRuleId: "ff8080814dd3bdd0014df6858808020e", costCenterName: "新版差旅系统-测试新版部", costCenterId: "51127", departureDate: 1487865600000, returnDate: 1487952000000, purpose: "因公出行", reason: "谈业务", destinations: ["北京","上海"], uids: ["51127"], opinions: nil)
        let bag = DisposeBag()
        createEmptyOrder()
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
    /// 获取公司自定义项
    func testCustomConfig(){
        let expectation = self.expectation(description: "获取公司自定义项 - router")
        let provider = RxMoyaProvider<CoNewOrdersRouter>()
        let bag = DisposeBag()
        provider
            .request(.customConfig())
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
    /// 订单取消
    func testOrderCancel(){
        let expectation = self.expectation(description: "订单取消 - router")
        let provider = RxMoyaProvider<CoNewOrdersRouter>()
        let bag = DisposeBag()
        provider
            .request(.cancelOrder("1000001509"))
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
        let provider = RxMoyaProvider<CoNewOrdersRouter>()
        let bag = DisposeBag()
        provider
            .request(.confirmOrder("1000001508"))
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
    /// 订单撤回
    func testOrderRevoke(){
        let expectation = self.expectation(description: "订单撤回 - router")
        let provider = RxMoyaProvider<CoNewOrdersRouter>()
        let bag = DisposeBag()
        provider
            .request(.revokeOrder("1000001510"))
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
    /// 订单送审
    ///
    /// - Returns: 审批返回数据
    private func approvalOrder() -> Observable<Response> {
        let provider = RxMoyaProvider<CoNewOrdersRouter>()
        var orderNo = ""
        //查询订单审批人信息并送审
        return createEmptyOrder()
            .map{ order -> Observable<[(key:Int,value:[CoManagerListItem])]> in
                let json = JSON(data: order.data)["content"]
                orderNo = json["orderNo"].stringValue
                return CoNewOrderService.sharedInstance.getManagers(orderNo)
            }
            .concat()
            .map{ managers -> Observable<Response> in
                let apverIds = managers.map{ $0.value[0].apverUid }
                return provider
                    .request(.submitOrder(orderNo,["apverIds":apverIds]))
                    .debugHttp(true)
        }.concat()
    }
    /// 订单送审
    func testOrderCommit(){
        let expectation = self.expectation(description: "订单送审 - router")
        let bag = DisposeBag()
        approvalOrder().subscribe{ event in
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
    
    /// 获取订单审批人信息
    func testOrderMangers(){
        let expectation = self.expectation(description: "获取订单审批人信息 - router")
        let provider = RxMoyaProvider<CoNewOrdersRouter>()
        let bag = DisposeBag()
        provider
            .request(.managers("1000001852"))
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
}
