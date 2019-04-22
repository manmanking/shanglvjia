//
//  SpecialProductService.swift
//  shop
//
//  Created by manman on 2017/7/5.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import SwiftyJSON


/// 单例
final class SpecialProductService {
    static let sharedInstance = SpecialProductService()
    private init() {} // 阻止其他对象使用这个类的默认的'()'初始化方法
}

// MARK: - 旅游相关service
extension  SpecialProductService: Validator{

    
    func getSpecialProductCategory()->Observable<[SpecialProductCategoryModel]> {
        let provider = RxMoyaProvider<SpecialRouter>()
        return provider
            .request(.mainCategory)
            .debugHttp(true)
            .validateJustReturn(to:[SpecialProductCategoryModel.self])
//
//        
        
    }
    
    
    
    /// 获取特价产品
    ///
    /// - Parameter form: 查询条件
    /// - Returns: 查询结果
    func getList(form:Dictionary<String,Any>) ->Observable<[TravelListItem]> {
        let provider = RxMoyaProvider<SpecialRouter>()
        return provider
                .request(.list(form))
                .debugHttp(true)
                .validateJustReturn(to:[TravelListItem.self])
    }



    /// 查询价格列表
    ///
    /// - Parameter form: 查询条件
    /// - Returns:
    func searchPrice(id:String ,categoryId:String ,_ form:TravelForm.SpecialPriceSearch) -> Observable<[SpecialPriceListItem]> {
        let provider = RxMoyaProvider<SpecialRouter>()
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
        let provider = RxMoyaProvider<SpecialRouter>()
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
        let provider = RxMoyaProvider<SpecialRouter>()
        return provider
            .request(.categorys(id: id))
            .debugHttp(true)
            .validateJustReturn(to: [TravelCategorys.self])
    }
    
    /// 提交特价订单
    ///
    /// - Parameter id:
    /// - Returns:
    func submitSpecial(_ form:TravelForm.OrderSpecialInfo) -> Observable<TravelResult> {
        let provider = RxMoyaProvider<SpecialRouter>()
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
            .request(.submitSpecial(form.toDict()))
            .debugHttp(true)
            .validateJustReturn(to: TravelResult.self)
    }
    
    ///旅游首页产品信息
    ///
    /// - Parameters:
    ///   - type:
    ///   - departure:
    /// - Returns
    func advs(_ form:AdvsModel) -> Observable<[TravelAdvListResponse]> {

        let provider = RxMoyaProvider<SpecialRouter>()
        return provider
            .request(.advs(form.toDict()))
            .debugHttp(true)
            .validateJustReturn(to: [TravelAdvListResponse.self])
    }

}
