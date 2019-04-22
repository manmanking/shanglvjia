//
//  CarouselResponse.swift
//  shanglvjia
//
//  Created by manman on 2018/6/1.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import SwiftyJSON
import Moya_SwiftyJSONMapper

class CarouselResponse: NSObject,ALSwiftyJSONAble {

    var herf:String = ""// (string, optional),
    var url:String = ""// (string, optional)
    override init() {
        
    }
    
    required init?(jsonData: JSON) {
        herf = jsonData["herf"].stringValue
        url = jsonData["url"].stringValue
    }
    
    
}
