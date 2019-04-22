//
//  PersonalFlightListResponse.swift
//  shanglvjia
//
//  Created by manman on 2018/4/8.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import SwiftyJSON
import Moya_SwiftyJSONMapper

class PersonalFlightListResponse: NSObject,ALSwiftyJSONAble {

    var count:NSInteger = 0
    var personalFlightInfos:[PersonalFlightInfo] = Array()
    var total:NSInteger = 0
    
    override init() {
        
    }
    
    required init(jsonData result:JSON){
        self.count = result["count"].intValue
        self.total = result["total"].intValue
        self.personalFlightInfos = result["personalFlightInfos"].arrayValue.map{PersonalFlightInfo(jsonData:$0)}//personalFlightInfos(jsonData )
    }
    
    class PersonalFlightInfo: NSObject,ALSwiftyJSONAble {
        var arrAirport:String = ""
        var arrTerm:String = ""
        var arrTime:String = ""
        var arrCity:String = ""
        var arrDate:String = ""
        var depAirport:String = ""
        var depDate:String = ""
        var depCity:String = ""
        var depTerm:String = ""
        var depTime:String = ""
        var flightNo:String = ""
        
        override init() {
            
        }
        
        required init(jsonData result:JSON){
            self.arrCity = result["arrCity"].stringValue
            self.arrAirport = result["arrAirport"].stringValue
            self.arrTerm = result["arrTerm"].stringValue
            self.arrTime = result["arrTime"].stringValue
            self.arrDate = result["arrDate"].stringValue
            self.depAirport = result["depAirport"].stringValue
            self.depDate = result["depDate"].stringValue
            self.depCity = result["depCity"].stringValue
            self.depTerm = result["depTerm"].stringValue
            self.depTime = result["depTime"].stringValue
            self.flightNo = result["flightNo"].stringValue
        }
        
    }
    
  
    
    
}
