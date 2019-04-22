//
//  PersonalHotelServices.swift
//  shanglvjia
//
//  Created by manman on 2018/7/30.
//  Copyright © 2018年 TBI. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import SwiftyJSON

final class PersonalHotelServices {
    static let sharedInstance = PersonalHotelServices()
    private init() {}
}
// MARK: - 签证相关service
extension  PersonalHotelServices: Validator{
    
    
    
    /// 定投酒店列表
    func hotelSpecialList(request:SpecialHotelListRequest)->Observable<SpecialHotelListResponse> {
        
        let provider = RxMoyaProvider<PersonalHotelRouter>()
        return provider
            .request(.specialProductList(request.mj_keyValues() as! [String : Any]))
            .debugHttp(true)
            .validateJustReturn(to: SpecialHotelListResponse.self)
    }
    
    
    /// 定投 酒店 详情
    func hotelSpecialProductDetail(request:SpecialHotelDetailRequest)->Observable<SpecialHotelDetailResponse> {
        
        let provider = RxMoyaProvider<PersonalHotelRouter>()
        return provider
            .request(.specialProductDetail(request.mj_keyValues() as! [String : Any]))
            .debugHttp(false)
            .validateJustReturn(to: SpecialHotelDetailResponse.self)
    }
    
    
    /// 个人 酒店生单
    func hotelSpecialProductSubmitOrder(request:SubmitHotelOrderRequest)->Observable<PersonalSubmitHotelOrderResponse> {
        let provider = RxMoyaProvider<PersonalHotelRouter>()
        return provider
            .request(.specialProductSubmitOrder(request.mj_keyValues() as! [String : Any]))
            .debugHttp(true)
            .validateJustReturn(to: PersonalSubmitHotelOrderResponse.self)
    }
    /// 个人 普通 酒店列表
    func psersonalHotelList(request:PersonalNormalHotelListRequest)->Observable<PersonalNormalHotelListResponse> {
        
        let provider = RxMoyaProvider<PersonalHotelRouter>()
        return provider
            .request(.personalHotelList(request.mj_keyValues() as! [String : Any]))
            .debugHttp(true)
            .validateJustReturn(to: PersonalNormalHotelListResponse.self)
    }

    
    /// 个人 普通 酒店列表
    func psersonalHotelDetail(request:PersonalNormalHotelListRequest)->Observable<PersonalNormalHotelListResponse> {
        
        let provider = RxMoyaProvider<PersonalHotelRouter>()
        return provider
            .request(.personalHotelList(request.mj_keyValues() as! [String : Any]))
            .debugHttp(true)
            .validateJustReturn(to: PersonalNormalHotelListResponse.self)
    }
    
    

    /// 获取酒店详情
    func personalHotelDetail(request:PersonalHotelRoomDetailRequest)->Observable<PersonalHotelDetailResult> {
        let provider = RxMoyaProvider<HotelsRouter>()
        return provider
            .request(.personalHotelDetail(request.mj_keyValues() as! [String : Any]))
            .debugHttp(true)
            .validateJustReturn(to: PersonalHotelDetailResult.self)
    }
    
    
    
    
}

