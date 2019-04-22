//
//  FlightCommercialService.swift
//  shop
//
//  Created by SLMF on 2017/4/28.
//  Copyright © 2017年 zhangwangwang. All rights reserved.
//

import Foundation
import RxSwift
import Moya

final class CommercialFlightService {
    static let sharedInstance = CommercialFlightService()
    private init() {}
}

extension CommercialFlightService: Validator {
    
    func getList(_ form: CommercialFlightSearchForm) -> Observable<CommercialFlightSearchResultModel> {
        let provider = RxMoyaProvider<CommercialFlightsRouter>()
        return provider
            .request(.list(form.toDict()))
            .validateJustReturn(to: CommercialFlightSearchResultModel.self)
    }
    
}
