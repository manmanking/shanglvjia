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
import SwiftDate
@testable import shanglvjia

class FlightServiceTests: XCTestCase,CaseConfig {
    let service = FlightService.sharedInstance
    /// 查询航班信息
    func testSearch(){
        let expectation = self.expectation(description: "查询航班信息 - service")
        let form = FlightSearchForm(departCityCode: "TSN", arriveCityCode: "SHA", departDate: "2017-05-09")
        let bag = DisposeBag()
        service.search(form).subscribe{ event in
            if case .next(let e) = event {
                print(e.allCabin)
                print(e.allCompanyCode)
                print(e.lowestPrice)
                print(e.flightList.map{$0.price}.sorted())
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
    /// 查询航班信息并排序
    func testSearchSort(){
        let expectation = self.expectation(description: "查询航班信息并排序 - service")
        let form = FlightSearchForm(departCityCode: "TSN", arriveCityCode: "SHA", departDate: "2017-05-09")
        let bag = DisposeBag()
        service.search(form).subscribe{ event in
            if case .next(let e) = event {
                //测试价格排序
                let sortedPrice =  e.flightList.sorted(.priceAsc)
                print(sortedPrice.map{$0.price})
                //测试时间排序
                let sortedTime =  e.flightList.sorted(.timeAsc)
                print(sortedTime.map{$0.takeOffDateTime.string(format: .custom("HH:mm"))})
                
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
    /// 过滤公司
    func testSearchFilterCompany(){
        let expectation = self.expectation(description: "查询航班信息并过滤公司 - service")
        let form = FlightSearchForm(departCityCode: "TSN", arriveCityCode: "SHA", departDate: "2017-05-09")
        let bag = DisposeBag()
        service.search(form).subscribe{ event in
            if case .next(let e) = event {
                let list =  e.flightList
                let filterData = list.filterCompany(["CA","MU"])
                print(filterData.map{$0.legList.first!.marketAirlineCode})
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
    /// 过滤时间
    func testSearchFilterTime(){
        let expectation = self.expectation(description: "查询航班信息并过滤时间 - service")
        let form = FlightSearchForm(departCityCode: "TSN", arriveCityCode: "SHA", departDate: "2017-05-09")
        let bag = DisposeBag()
        service.search(form).subscribe{ event in
            if case .next(let e) = event {
                let list =  e.flightList.sorted(.timeAsc)
                let filterData = list.maxTimeLimit("19:00".date(format: .custom("HH:mm"))!.absoluteDate)
                .minTimeLimit("09:00".date(format: .custom("HH:mm"))!.absoluteDate)
                print(filterData.map{$0.takeOffDateTime.string(format: .custom("HH:mm"))})
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
    /// 过滤仓位
    func testSearchFilterCabin(){
        let expectation = self.expectation(description: "查询航班信息并过滤仓位 - service")
        let form = FlightSearchForm(departCityCode: "TSN", arriveCityCode: "SHA", departDate: "2017-05-09")
        let bag = DisposeBag()
        service.search(form).subscribe{ event in
            if case .next(let e) = event {
                let list =  e.flightList
                let filterData = list.filterCabin(["头等舱","经济舱"]).maxTimeLimit(Date()).minTimeLimit(Date()).sorted(.priceAsc)
                print(filterData.map{$0.cabinList.map{$0.cabinTypeText}})
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
    /// 提交航班信息
    func testCommit(){
//        BASE_URL = "http://localhost:8081/api/v1"
//        let expectation = self.expectation(description: "预订机票 - service")
//        let bag = DisposeBag()
//        let userService = UserService.sharedInstance
//        let flightService = FlightService.sharedInstance
//        //登录表单
//        let loginForm = PersonalLoginUserForm(userName: "18630857599", passWord: "18630857599")
//        //查询机票表单
//        let searchDate = (DateInRegion() + 1.day).string(custom: "YYYY-MM-dd")
//        let flightSearchForm = FlightSearchForm(departCityCode: "SHA", arriveCityCode: "TSN", departDate:searchDate)
//        let loginObserable = userService.personalLogin(loginForm)
//        let flightSearchObserable = flightService.search(flightSearchForm)
//        Observable.combineLatest(loginObserable,flightSearchObserable).map{user,flight -> Observable<String> in
////            let form:[String : Any] = [
////                "passengers":[["name":"张三",
////                               "cardType":"1",
////                               "cardNo":"11"]],
////                "orderContact":["contactEmail":"11@qq.com",
////                                "contactPhone":"123123213",
////                                "contactName":"2312321"
////                ],
////                "orderTotalAmount":flight.flightList[0].cabinList[0].price+50,
////                "searchVo":["departCityCode":flightSearchForm.departCityCode,
////                            "arriveCityCode":flightSearchForm.arriveCityCode,
////                            "departDate":flightSearchForm.departDate,
////                            "departCabinId":flight.flightList[0].cabinList[0].id
////                ]
////            ]
//            //let passenger = FlightCommitForm.Passenger(name: "张三", cardType: "1", cardNo: "11", depCards: nil, rtnCards: nil)
//            let contact = FlightCommitForm.Contact(contactEmail: "11@qq.com", contactPhone: "2312321", contactName: "2312321")
//            let price = flight.flightList[0].cabinList[0].price
//            let search = FlightCommitForm.Search(departCityCode: flightSearchForm.departCityCode,
//                                                 arriveCityCode: flightSearchForm.arriveCityCode,
//                                                 departDate: flightSearchForm.departDate,
//                                                 departCabinId: flight.flightList[0].cabinList[0].id,
//                                                 returnCabinId: nil,
//                                                 returnDate: nil)
//            let form = FlightCommitForm(passengers: [passenger], orderInvoice: nil, orderContact: contact, orderTotalAmount: price, searchVo: search)
//            return self.service.commit(form)
//            
//            }.concat().subscribe{ event in
//                if case .next(let e) = event {
//                    print(e)
//                    expectation.fulfill()
//                }
//                if case .error(let e) = event {
//                    print(e)
//                    expectation.fulfill()
//                }
//                
//            }.disposed(by: bag)
//        waitForExpectations(timeout: timeout){ error in
//            if let e = error {
//                XCTFail(e.localizedDescription)
//            }
//        }
    }
}


struct Flight {
    let name:String
    let cabin:Cabin
}
struct Cabin {
    let name:String
}
