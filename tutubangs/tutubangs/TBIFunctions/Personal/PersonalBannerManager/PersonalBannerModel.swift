//
//  PersonalBannerModel.swift
//  tutubangs
//
//  Created by manman on 2018/10/12.
//  Copyright © 2018 manman. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON


class PersonalBannerModel: NSObject,ALSwiftyJSONAble,NSCoding {
    
    var airBanner:[String] = Array()
    
    var hotelBanner:[String] = Array()
    
    var tripBanner:[String] = Array()
    
    var visaBanner:[String] = Array()
    
    
    
    override init() {
        
    }
    
    required init?(jsonData: JSON) {
        airBanner = jsonData["1"].arrayValue.map{$0.stringValue}
        hotelBanner = jsonData["2"].arrayValue.map{$0.stringValue}
        tripBanner = jsonData["3"].arrayValue.map{$0.stringValue}
        visaBanner = jsonData["4"].arrayValue.map{$0.stringValue}
    }
    
    
    func encode(with aCoder: NSCoder) {
        self.mj_encode(aCoder)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.mj_decode(aDecoder)
    }
    
    
    
    

}
