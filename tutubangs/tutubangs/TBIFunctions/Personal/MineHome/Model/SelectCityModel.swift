//
//  SelectCityModel.swift
//  shanglvjia
//
//  Created by tbi on 24/08/2018.
//  Copyright © 2018 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON

class SelectCityModel: NSObject ,ALSwiftyJSONAble{
    

        var key :String = ""
        var value :String = ""
        
        override init() {
            
        }
        
        required init?(jsonData: JSON) {
            key = jsonData["key"].stringValue
            value = jsonData["value"].stringValue
            
        }
    
    
}
