//
//  FilialeItemModel.swift
//  shanglvjia
//
//  Created by manman on 2018/4/26.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON

class FilialeItemModel: NSObject,ALSwiftyJSONAble{
    
    ///  : "天津奥德行津盛",
    var branchName:String = ""
    
    ///  : "38.975301447094299",
    var lat:String = ""
    
    ///  : "117.39332189926907"
    var lon:String = ""
    
    override init() {
        
    }
    required init?(jsonData: JSON) {
        self.branchName = jsonData["branchName"].stringValue
        self.lat = jsonData["lat"].stringValue
        self.lon = jsonData["lon"].stringValue
    }

}
