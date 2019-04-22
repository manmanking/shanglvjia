//
//  PersonalPassengerServices.swift
//  shanglvjia
//
//  Created by manman on 2018/7/24.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import RxSwift
import Moya
import SwiftyJSON

final class PersonalPassengerServices {
    
    static let sharedInstance = PersonalPassengerServices()
    private init() { }
        
}

extension  PersonalPassengerServices: Validator{


    func passengerAdd(request:PersonalTravellerInfoRequest) -> Observable<Bool> {
        
        
        let provider = RxMoyaProvider<PersonalPassengerRouter>()
        return provider
            .request(.add(request.mj_keyValues() as! [String : Any]))
            .debugHttp(true)
            .validateResponse()
            .map({ (json) -> Bool in
                return json.stringValue == "success" ? true : false
            })
        
        
        
    }
    func passengerDelete(passengerId:String) -> Observable<Bool> {
        
        let request:[String:Any] = ["travellerId":passengerId]
        
        let provider = RxMoyaProvider<PersonalPassengerRouter>()
        return provider
            .request(.delete(request))
            .debugHttp(true)
            .validateResponse()
            .map({ (jsonData) -> Bool in
                return jsonData.stringValue == "success" ? true : false
            })
        
        
        
    }
    func passengerModify(request:PersonalTravellerInfoRequest) -> Observable<Bool> {
        let provider = RxMoyaProvider<PersonalPassengerRouter>()
        return provider
            .request(.modify(request.mj_keyValues() as! [String : Any]))
            .debugHttp(true)
            .validateResponse()
            .map({ (json) -> Bool in
                return json.stringValue == "success" ? true : false
            })
        
        
        
    }
    func passengerList(request:String) -> Observable<[PersonalTravellerInfoRequest]> {
        let request:[String:Any] = ["userId":request]
        
        let provider = RxMoyaProvider<PersonalPassengerRouter>()
        return provider
            .request(.list(request))
            .debugHttp(true)
            .validateJustReturn(to:[PersonalTravellerInfoRequest.self] )
    }
    



}
