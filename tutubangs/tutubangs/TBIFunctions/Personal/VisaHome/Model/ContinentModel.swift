//
//  ContinentModel.swift
//  shanglvjia
//
//  Created by manman on 2018/7/17.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON

class ContinentModel: NSObject,ALSwiftyJSONAble {
    
    var ctId:String = ""
    var data:[CountryModel] = Array()
    var ctName:String = ""
    

    override init() {
        
    }
    
    required init?(jsonData: JSON) {
        
        ctId = jsonData["ctId"].stringValue
        data = jsonData["data"].arrayValue.map{CountryModel.init(jsonData: $0)!}
        ctName = jsonData["ctName"].stringValue
    }
    
    
    class CountryModel: NSObject,ALSwiftyJSONAble {
        
        var countryCode:String = ""
        var countryNameCn:String = ""
        
        override init() {
            
        }
        
        
        required init?(jsonData: JSON) {
            countryCode = jsonData["countryCode"].stringValue
            countryNameCn = jsonData["countryNameCn"].stringValue
        }
        
        
        
    }

}
