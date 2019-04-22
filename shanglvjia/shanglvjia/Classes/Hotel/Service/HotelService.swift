//
//  HotelService.swift
//  shop
//
//  Created by akrio on 2017/4/23.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON
import Moya
/// 单例
final class HotelService {
    static let sharedInstance = HotelService()
    private init() {} // 阻止其他对象使用这个类的默认的'()'初始化方法
}

extension  HotelService: Validator{

    /// 获取酒店列表
    ///
    /// - Parameter form: 查询条件
    /// - Returns: 查询结果
    func getList(_ form:HotelSearchForm) -> Observable<[HotelListItem]>{
        let provider = RxMoyaProvider<HotelsRouter>()
        return provider
            .request(.list(form.toDict()))
            .debugHttp(true)
            .validateJustReturn(to: [HotelListItem.self])
    }
    
    /// 获取酒店详情
    ///
    /// - Parameter form: 查询条件
    /// - Returns: 查询结果
    func getDetail(_ form:HotelDetailForm) -> Observable<OHotel>{
        let provider = RxMoyaProvider<HotelsRouter>()
        return provider
            .request(.detail(id: form.hotelId, parameters: ["arrivalDate":form.arrivalDate,"departureDate":form.departureDate]))
            .debugHttp(true)
            .validateJustReturn(to: OHotel.self)
    
    }
//    /// 获取酒店详情  new
//    ///
//    /// - Parameter form: 查询条件
//    /// - Returns: 查询结果
//    func getDetail(_ form:HotelDetailForm) -> Observable<String>{
//        let provider = RxMoyaProvider<HotelsRouter>()
//        let data =  provider
//                .request(.detail(id: form.hotelId, parameters: ["arrivalDate":form.arrivalDate,"departureDate":form.departureDate]))
//                .validateResponse()
//        return ""
//        
//    }
//    
    
    
    /// 获取热门城市
    ///
    /// - Returns: 查询结果
    func getHotCity() -> Observable<[String]>{
        let provider = RxMoyaProvider<HotelsRouter>()
        return provider
            .request(.hotCity)
            .validateResponse()
            .map{$0.arrayValue.map{$0.stringValue}}
    }
    /// 获取商圈 (暂时无用)
    ///
    /// - Parameter id: 城市id
    /// - Returns: 商圈信息
    func getLandmark(_ id:String) -> Observable<[(String,String)]>{
        let provider = RxMoyaProvider<HotelsRouter>()
        return provider
            .request(.cityInfo(["cityId":id]))
            .validateResponse()
            .map{$0.arrayValue.map{($0.stringValue,$0.stringValue)}}
    }
    /// 验证信息卡信息
    ///
    /// - Parameter card: 卡号
    /// - Returns: 是否为信用卡 是否需要cvv
    func validateCvv(_ card:String) -> Observable<(validate:Bool,cvv:Bool)>{
        let provider = RxMoyaProvider<HotelsRouter>()
        return provider
            .request(.validateCvv(["cardId":card]))
            .validateResponse()
            .map{(validate:$0["result"]["isValid"].boolValue,cvv:$0["result"]["isNeedVerifyCode"].boolValue)}
    }
    
    /// 个人酒店下订单
    ///
    /// - Parameter order: 
    func commit(order:HotelOrderInfo) -> Observable<String>{
        let provider = RxMoyaProvider<HotelsRouter>()
        return provider
            .request(.commit(parameters: order.toDict()))
            .debugHttp(true)
            .validateResponse()
            .map{$0["orderId"].stringValue}
        
    }
    
    ///计算担保金额
    func caculateGuaranteeAmount(parameter:Dictionary<String,Any>) ->Observable<String> {
        let provider = RxMoyaProvider<HotelsRouter>()
        return provider.request(.guarantee(parameters: parameter))
                    .debugHttp(true)
                    .validateResponse()
                    .map{($0.stringValue)}
    }
    
    func verifyCredit(parameters:Dictionary<String,Any>) -> Observable<(valid:Bool,cvv:Bool)> {
        let provider = RxMoyaProvider<HotelsRouter>()
        return provider.request(.testcvv(parameters: parameters))
                .debugHttp(true)
                .validateResponse()
                .map{(valid:$0["result"]["isValid"].boolValue,cvv:$0["result"]["isNeedVerifyCode"].boolValue)}
    }
    
    
    
    ///MARK:----OBT----
    /// 获取酒店列表
    ///
    /// - Parameter form: 查询条件
    /// - Returns: 查询结果
    func getHotelList(_ form:HotelListRequest) -> Observable<HotelListNewModel>{
        let provider = RxMoyaProvider<HotelsRouter>()
        return provider
            .request(.hotelList(form.mj_keyValues() as! [String : Any]))
            .debugHttp(true)
            .validateJustReturn(to: HotelListNewModel.self)
    }

    
    /// 获取分公司
    func getFiliale(city:String) ->Observable<[FilialeItemModel]> {
        let corpCode:String = DBManager.shareInstance.userDetailDraw()?.busLoginInfo.userBaseInfo.corpCode ?? ""
        let requestDic:[String:Any] = ["corpCode":corpCode,"cityName":city]
        let provider = RxMoyaProvider<HotelsRouter>()
        return provider
            .request(.filialeList(requestDic))
            .debugHttp(true)
            .validateJustReturn(to: [FilialeItemModel.self])
    }
    
    /// 获取酒店详情
    func getHotelDetail(request:HotelRoomDetailRequest)->Observable<HotelDetailResult> {
        let provider = RxMoyaProvider<HotelsRouter>()
        return provider
            .request(.hotelDetail(request.mj_keyValues() as! [String : Any]))
            .debugHttp(true)
            .validateJustReturn(to: HotelDetailResult.self)
    }
    
    /// 提交订单
    func hotelSubmitOrder(request:SubmitOrderVO) -> Observable<[String]> {
        let provider = RxMoyaProvider<HotelsRouter>()
        return provider
            .request(.hotelSubmitOrder(request.mj_keyValues() as! [String : Any]))
            .debugHttp(true)
            .validateResponse().map({ (json) -> [String] in
                return json.arrayValue.map{$0.stringValue}
            })
    }
    
    /// 获取担保金额
    func hotelGuaranteeAmount(request:GuaranteeAmountRequest) -> Observable<String> {
        let provider = RxMoyaProvider<HotelsRouter>()
        return provider
            .request(.hotelGuaranteeAmount(request.mj_keyValues() as! [String : Any]))
            .debugHttp(true)
            .validateResponse().map({ (json) -> String in
                return json.stringValue
            })
    }
    
    func hotelCreditVerify(creditNo:String) -> Observable<(valid:Bool,cvv:Bool)> {//
        let requestDic:[String:Any] = ["cardNo":creditNo]
        let provider = RxMoyaProvider<HotelsRouter>()
        return provider
            .request(.hotelCreditVerify(requestDic))
            .debugHttp(true)
            .validateResponse()
            .map{
                (valid:$0["IsValid"].boolValue,cvv:$0["IsNeedVerifyCode"].boolValue)

        }
    }
    
    
    
}
