//
//  PersonalTopicModel.swift
//  tutubangs
//
//  Created by tbi on 2018/10/22.
//  Copyright © 2018 manman. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON

class PersonalTopicModel: NSObject,ALSwiftyJSONAble {

    var contentName : String = ""
    var dayCount : String = ""
    var dept : String = ""
    var image : String = ""
    var nightCount : String = ""
    var price : String = ""
    var productId : String = ""
    var sideName : String = ""
    var type : String = ""
    override init() {
        
    }
    
    
    required init?(jsonData: JSON) {
        contentName = jsonData["contentName"].stringValue
        dayCount = jsonData["dayCount"].stringValue
        dept = jsonData["dept"].stringValue
        image = jsonData["image"].stringValue
        nightCount = jsonData["nightCount"].stringValue
        price = jsonData["price"].stringValue
        productId = jsonData["productId"].stringValue
        sideName = jsonData["sideName"].stringValue
        type = jsonData["type"].stringValue
    }
}
