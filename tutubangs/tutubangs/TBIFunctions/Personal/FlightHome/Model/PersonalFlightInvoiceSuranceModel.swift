//
//  PersonalFlightInvoiceSuranceModel.swift
//  tutubangs
//
//  Created by tbi on 2018/10/24.
//  Copyright © 2018 manman. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON

class PersonalFlightInvoiceSuranceModel:  NSObject,ALSwiftyJSONAble  {

    var surances:[PTravelNearbyDetailModel.NearbySuranceResponse] = Array()
    var invoices:[PTravelNearbyDetailModel.InvoicesModel] = Array()
    override init() {
        
    }
     required init?(jsonData: JSON) {
        surances = jsonData["surances"].arrayValue.map{PTravelNearbyDetailModel.NearbySuranceResponse.init(jsonData: $0)!}
        invoices = jsonData["invoices"].arrayValue.map{PTravelNearbyDetailModel.InvoicesModel.init(jsonData: $0)!}
    }
}
