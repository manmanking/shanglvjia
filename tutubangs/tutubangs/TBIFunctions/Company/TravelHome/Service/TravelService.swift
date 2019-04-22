//
//  TravelService.swift
//  shop
//
//  Created by akrio on 2017/6/27.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import SwiftyJSON

/// 单例
final class TravelService {
    static let sharedInstance = TravelService()
    private init() {} // 阻止其他对象使用这个类的默认的'()'初始化方法
}

// MARK: - 旅游相关service
extension  TravelService: Validator{
    /// 查询订单列表
    ///
    /// - Parameter form: 查询条件
    /// - Returns:
    func search(_ form:TravelForm.Search) -> Observable<[TravelListItem]> {
        let provider = RxMoyaProvider<TravelRouter>()
        return provider
            .request(.list(form.toDict()))
            .debugHttp(true)
            .validateJustReturn(to: [TravelListItem.self])
    }
    /// 查询价格列表
    ///
    /// - Parameter form: 查询条件
    /// - Returns:
    func searchPrice(id:String ,categoryId:String ,_ form:TravelForm.SpecialPriceSearch) -> Observable<[SpecialPriceListItem]> {
        let provider = RxMoyaProvider<TravelRouter>()
        return provider
            .request(.price(id: id,categoryId: categoryId,form.toDict()))
            .debugHttp(true)
            .validateJustReturn(to: [SpecialPriceListItem.self])
    }
    
    /// 查询产品详情
    ///
    /// - Parameter id:
    /// - Returns:
    func detail(_ id:String) -> Observable<TravelListItem> {
        let provider = RxMoyaProvider<TravelRouter>()
        return provider
            .request(.detail(id: id))
            .debugHttp(true)
            .validateJustReturn(to: TravelListItem.self)
    }
    
    /// 获取产品类别
    ///
    /// - Parameter id:
    /// - Returns:
    func categorys(_ id:String) -> Observable<[TravelCategorys]> {
        let provider = RxMoyaProvider<TravelRouter>()
        return provider
            .request(.categorys(id: id))
            .debugHttp(true)
            .validateJustReturn(to: [TravelCategorys.self])
    }
    
    /// 提交旅游订单
    ///
    /// - Parameter id:
    /// - Returns:
    func submitTravel(_ form:TravelForm.OrderSpecialInfo) -> Observable<TravelResult> {
        let provider = RxMoyaProvider<TravelRouter>()
        guard form.contactName.value.isNotEmpty else {
            return validateMessageObservable("common.validate.isempty.message","联系人姓名")
        }
        guard form.contactPhone.value.validate(.phone) else {
            return validateMessageObservable("common.validate.phone.message")
        }
        if form.isNeedInvoice == "1"{
            guard form.invoice.invoiceTitle.value.isNotEmpty else {
                return validateMessageObservable("common.validate.isempty.message","发票抬头")
            }
            guard form.logistics.logisticsName.value.isNotEmpty else {
                return validateMessageObservable("common.validate.isempty.message","收件人姓名")
            }
            guard form.logistics.logisticsAddress.value.isNotEmpty else {
                return validateMessageObservable("common.validate.isempty.message","详细地址")
            }
            guard form.logistics.logisticsPhone.value.validate(.phone) else {
                return validateMessageObservable("common.validate.phone.message")
            }
        }
        for index in 0..<(form.orderSpecialPersonInfoList?.count ?? 0) {
            guard (form.orderSpecialPersonInfoList?[index].personIdCard?.isNotEmpty ?? true) else {
                return validateMessageObservable("请选择出行人")
            }
        
        }
                
        return provider
            .request(.submitTravel(form.toDict()))
            .debugHttp(true)
            .validateJustReturn(to: TravelResult.self)
    }


    
    
    /// 查询出行人列表
    ///
    /// - Returns:
    func travellerList() -> Observable<[TravellerListItem]> {
        let provider = RxMoyaProvider<TravelRouter>()
        return provider
            .request(.travellerList)
            .debugHttp(true)
            .validateJustReturn(to: [TravellerListItem.self])
    }
    
    /// 修改或新增人
    ///
    /// - Parameter form:
    /// - Returns:
    func updateTraveller(_ form:TravellerForm) -> Observable<Bool> {
        let provider = RxMoyaProvider<TravelRouter>()
        
        guard form.nameChi.value.characters.count < 25 else{
            return validateMessageObservable("common.validate.islength.message","中文姓名")
        }
        guard form.nameEng.value.characters.count < 50 else{
            return validateMessageObservable("common.validate.islength.message","英文姓名")
        }
        guard form.passport.value.characters.count < 10 else{
            return validateMessageObservable("common.validate.islength.message","护照")
        }
        guard form.country.value.characters.count < 45 else{
            return validateMessageObservable("common.validate.islength.message","国籍")
        }
        guard form.nameChi.value.isChinese() else {
            return validateMessageObservable("common.validate.format.message","中文姓名")
        }
        
        guard form.nameChi.value.isNotEmpty else {
            return validateMessageObservable("common.validate.isempty.message","中文姓名")
        }
        
        guard form.phone.value.validate(.phone) else {
            return validateMessageObservable("common.validate.phone.message","手机号码")
        }
        guard form.idCard.value.validateIDCardNumber() else {
            return validateMessageObservable("common.validate.card.message")
        }
//        guard form.idCard.value.validate(.card) else {
//            return validateMessageObservable("common.validate.card.message")
//        }
        
        return provider
            .request(.updateTraveller(form.toDict()))
            .debugHttp(true)
            .validateResponse()
            .map{$0.boolValue}
    }
    
    /// 删除人
    ///
    /// - Parameter id:
    /// - Returns:
    func deleteTraveller(_ id:String) -> Observable<Int> {
        let provider = RxMoyaProvider<TravelRouter>()
        return provider
            .request(.deleteTraveller(["guid":id]))
            .debugHttp(true)
            .validateResponse()
            .map{$0.intValue}
    }
    
    
    
    /// 提交定制化旅游
    ///
    /// - Parameter id:
    /// - Returns:
    func submitCustomTravelForm(travelOrderForm:TravelDIYIntentOrder) -> Observable<Bool> {
        let provider = RxMoyaProvider<TravelRouter>()
        return provider
            .request(.submitCustomTravel(travelOrderForm.toDict()))
            .debugHttp(true)
            .validateResponse()
            .map{_ in  true}
    }
    
    
    
    /// 获取家属列表
    ///
    /// - Parameter id:
    /// - Returns:
    func getFamilyMemberList() -> Observable<[TravellerForm]> {
        let provider = RxMoyaProvider<TravelRouter>()
        return provider
            .request(.familyTraveller())
            .debugHttp(true)
            .validateJustReturn(to: [TravellerForm.self])
        
    }
    
    /// 添加家属成员
    ///
    /// - Parameter id:
    /// - Returns:
    func addFamilyMember(familyTraveller:TravellerForm) -> Observable<Bool> {
        let provider = RxMoyaProvider<TravelRouter>()
        return provider
            .request(.familyAddTraveller(familyTraveller.toDict()))//(FamilyTraveller.toDict()))
            .debugHttp(true)
            .validateResponse()
            .map{_ in  true}
    }
    
    
    
    
}
