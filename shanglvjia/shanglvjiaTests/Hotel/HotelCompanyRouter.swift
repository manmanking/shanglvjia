//
//  HotelCompanyRouter.swift
//  shanglvjia
//
//  Created by manman on 2017/6/7.
//  Copyright © 2017年 TBI. All rights reserved.
//

import XCTest
import Moya
import RxSwift
import SwiftyJSON
@testable import shanglvjia

class HotelCompanyRouter: XCTestCase,CaseConfig {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    /// 获取企业个性化设置 //GET v1/new_orders/configs
    func testCompanyConfig(){
        let expectation = self.expectation(description: "获取企业个性化设置 - router")
        let provider = RxMoyaProvider<CompanyTravellerRouter>()
        let bag = DisposeBag()
        provider
            .request(.companyConfig())
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
    
}
