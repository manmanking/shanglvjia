//
//  VisaServices.swift
//  shanglvjia
//
//  Created by manman on 2018/7/16.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import RxSwift
import Moya
import SwiftyJSON

final class VisaServices {
    static let sharedInstance = VisaServices()
    private init() {}
}
// MARK: - 签证相关service
extension  VisaServices: Validator{

    
    /// 获取签证列表
    func getVisaList(request:VisaProductListRequest)->Observable<VisaProductListResponse> {
        
        
        let provider = RxMoyaProvider<VisaRouter>()
        return provider
            .request(.list(request.mj_keyValues() as! [String : Any]))
            .debugHttp(true)
            .validateJustReturn(to: VisaProductListResponse.self)
    }
    
    
    /// 获取国家列表
    func getCountryList()->Observable<[ContinentModel]> {
        let provider = RxMoyaProvider<VisaRouter>()
        return provider
            .request(.countyList())
            .debugHttp(true)
            .validateJustReturn(to: [ContinentModel.self])
    }
    
    func getVisaDetail(productId:String) ->Observable<[VisaOrderAddResquest.TravelSuranceResponse]>{
        let provider = RxMoyaProvider<VisaRouter>()
        return provider
            .request(.detail(productId:productId))
            .debugHttp(true)
            .validateResponse()
            .map({ (jsonData) -> [VisaOrderAddResquest.TravelSuranceResponse] in
                return  jsonData["surances"].arrayValue.map{VisaOrderAddResquest.TravelSuranceResponse.init(jsonData: $0)!}
            })
    }
    
    
    
    func submitOrder(request:VisaOrderAddResquest)->Observable<PersonalVisaOrderResponse> {
        let provider = RxMoyaProvider<VisaRouter>()
        return provider
            .request(.submitOrderVisa(request.mj_keyValues() as! [String : Any]))
            .debugHttp(true)
            .validateJustReturn(to: PersonalVisaOrderResponse.self)
        
    }
    


}



