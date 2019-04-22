//
//  HotelServiceTests.swift
//  shanglvjia
//
//  Created by akrio on 2017/4/23.
//  Copyright © 2017年 TBI. All rights reserved.
//


import XCTest
import Moya
import RxSwift
import SwiftyJSON
import SwiftDate
@testable import shanglvjia

class HotelServiceTests: XCTestCase,CaseConfig {
    let hotelService = HotelService.sharedInstance
    let citysService = CitysService.sharedInstance
    override func setUp() {
        super.setUp()
//        BASE_URL = "http://172.17.18.124:8080/api/v1"
        let expectation = self.expectation(description: "登录个人用户 - service")
        let bag = DisposeBag()
        let form  = PersonalLoginUserForm(userName: "15321802998", passWord: "1234567")
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
    /// 获取酒店列表
    func testServiceList(){
        let expectation = self.expectation(description: "获取酒店列表 - service")
        let arrivalDate = Date() + 1.day
        let departureDate = Date() + 5.day
        let form = HotelSearchForm(cityId: "0101", cityName: "北京", arrivalDate: arrivalDate, departureDate: departureDate)
        let bag = DisposeBag()
        hotelService
            .getList(form)
            .debug()
            .subscribe{ event in
                if case .next(let e) = event {
                    print(e)
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
    func testServiceDetail(){
        let expectation = self.expectation(description: "获取酒店详情 - service")
        let arrivalDate = Date() + 1.day
        let departureDate = Date() + 5.day
        let form = HotelDetailForm(hotelId:"90847112",arrivalDate:arrivalDate,departureDate:departureDate)
        let bag = DisposeBag()
        hotelService
            .getDetail(form)
            .debug()
            .subscribe{ event in
                if case .next(let e) = event {
                    print(e)
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

    /// 获取热门城市列表
    func testServiceHotCity(){
        let expectation = self.expectation(description: "获取热门城市列表 - service")
        let bag = DisposeBag()
        hotelService
            .getHotCity()
            .subscribe{ event in
                if case .next(let e) = event {
                    print(e)
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
    /// 验证信息卡信息
    func testServiceValidateCvv(){
        let expectation = self.expectation(description: "验证信息卡信息 - service")
        let bag = DisposeBag()
        hotelService
            .validateCvv("6259061298906816")
            .subscribe{ event in
                if case .next(let e) = event {
                    print(e)
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
    ///提交酒店订单
    func testCommit(){
        let expectation = self.expectation(description: "提交酒店订单 - service")
        let bag = DisposeBag()
       
        let data = stestData()
        
        hotelService.commit(order: data)
            .subscribe{ event in
            if case .next(let e) = event {
                print(e)
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
    
    func stestData() -> HotelOrderInfo {
        var hotelOrder:HotelOrderInfo = HotelOrderInfo()
        hotelOrder.customerType = "1"
        //产品信息
        var hp:HotelOrderInfo.HotelProductParameters  = HotelOrderInfo.HotelProductParameters()
        hp.country = "86"
        hp.cityId = "0101"
        hp.hotelId = "20101512"
        hp.ratePlanId = "3798891"
        hp.roomTypeId = "0008"
        hp.arrivalDate = "2017-06-01"
        hp.departureDate = "2017-06-02"
        hotelOrder.hotelProductParameters = hp
        //房间客人信息
        var orc:HotelOrderInfo.OrderHotelRoomCustomer = HotelOrderInfo.OrderHotelRoomCustomer()
        orc.name = "张三"
        orc.phone = "13621186634"
        //房间信息
        var room:HotelOrderInfo.OrderHotelRoom = HotelOrderInfo.OrderHotelRoom()
        room.earliestArrivalTime = "13:00"
        room.latestArrivalTime = "18:00"
        room.noteToHotelBed  = "test"
        room.noteToHotels = "test"
        room.orderHotelRoomCustomersList = [orc]
        hotelOrder.orderHotelRoomList =  [room]
        //联系人信息
        var oc:HotelOrderInfo.OrderHotelContact = HotelOrderInfo.OrderHotelContact()
        oc.contactName = "张三"
        oc.contactPhone = "13621186634"
        hotelOrder.orderHotelContact = oc
        return hotelOrder
    }
    
    func companyConfig() {
        let expectation = self.expectation(description: "提交酒店订单 - service")
        let bag = DisposeBag()
        
//        HotelCompanyService(order: data)
//            .subscribe{ event in
//                if case .next(let e) = event {
//                    print(e)
//                    expectation.fulfill()
//                }
//                if case .error(let e) = event {
//                    print(e)
//                    expectation.fulfill()
//                }
//            }.disposed(by: bag)
//        
//        waitForExpectations(timeout: timeout){ error in
//            if let e = error {
//                XCTFail(e.localizedDescription)
//            }
//        }
        

    }
    
    func testCitysService(){
        let expectation = self.expectation(description: "城市区域列表测试 - service")
        let bag = DisposeBag()
        citysService.getDistrict(cityId: "0101")
            .subscribe{ event in
                if case .next(let e) = event {
                    print(e)
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
